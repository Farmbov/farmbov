import 'package:flutter/material.dart';

class BottomNavigationItem extends BottomNavigationBarItem {
  final String initialLocation;

  const BottomNavigationItem({
    required this.initialLocation,
    required super.icon,
    super.label,
    Widget? activeIcon,
  }) : super(
          activeIcon: activeIcon ?? icon,
        );
}
