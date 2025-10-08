import 'package:flutter/material.dart';

class AnimatedBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double elevation;

  const AnimatedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.elevation = 10.0,
  });

  @override
  State<AnimatedBottomNav> createState() => _AnimatedBottomNavState();
}

class _AnimatedBottomNavState extends State<AnimatedBottomNav> {
  @override
  Widget build(BuildContext context) {
    // 👇 Automatically adapt colors to light/dark theme
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        widget.backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final selectedColor =
        widget.selectedColor ?? (isDark ? Colors.blue[300]! : const Color(0xFF1E88E5));
    final unselectedColor =
        widget.unselectedColor ?? (isDark ? Colors.grey[400]! : const Color(0xFF9E9E9E));

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
            width: 0.6,
          ),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: widget.elevation,
              offset: const Offset(0, -2),
            ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final itemWidth = availableWidth / widget.items.length;
            final isCompact = itemWidth < 80;

            final iconSize = isCompact ? 22.0 : 26.0;
            final fontSize = isCompact ? 10.0 : 12.0;
            final verticalPadding = isCompact ? 4.0 : 8.0;

            return Container(
              height: isCompact ? 58 : 70,
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 4 : 10,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = index == widget.currentIndex;

                  return Expanded(
                    child: _NavItemWidget(
                      item: item,
                      isSelected: isSelected,
                      selectedColor: selectedColor,
                      unselectedColor: unselectedColor,
                      onTap: () => widget.onTap(index),
                      iconSize: iconSize,
                      fontSize: fontSize,
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NavItemWidget extends StatefulWidget {
  final NavItem item;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;
  final double iconSize;
  final double fontSize;

  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
    required this.iconSize,
    required this.fontSize,
  });

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _colorAnimation = ColorTween(
      begin: widget.unselectedColor,
      end: widget.selectedColor,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.isSelected) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _NavItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _controller.forward();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  widget.item.icon,
                  color: _colorAnimation.value,
                  size: widget.iconSize,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                widget.item.label,
                style: TextStyle(
                  color: _colorAnimation.value,
                  fontSize: widget.fontSize,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          );
        },
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  final String routeName;

  const NavItem({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}
