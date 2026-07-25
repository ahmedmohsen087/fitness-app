import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/text_styles.dart';

class CustomFilterTabBarItem {
  final String id;
  final String title;

  const CustomFilterTabBarItem({
    required this.id,
    required this.title,
  });
}

class CustomFilterTabBar extends StatefulWidget {
  final List<CustomFilterTabBarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final EdgeInsetsGeometry padding;

  const CustomFilterTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTabSelected,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  State<CustomFilterTabBar> createState() => _CustomFilterTabBarState();
}

class _CustomFilterTabBarState extends State<CustomFilterTabBar> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant CustomFilterTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToIndex(widget.selectedIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients || index < 0 || index >= widget.items.length) {
      return;
    }
    const itemEstimateWidth = 100.0;
    final targetOffset = (index * itemEstimateWidth) - 40.0;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final clampedOffset = targetOffset.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: widget.padding,
        itemCount: widget.items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          final item = widget.items[index];

          return GestureDetector(
            onTap: () => widget.onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orange : AppColors.lightBlack.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.orange : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  item.title,
                  style: isSelected
                      ? TextStyles.buttonTextStyle.copyWith(fontWeight: FontWeight.bold)
                      : TextStyles.bodyRegular16.copyWith(color: AppColors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
