import 'package:flutter/material.dart';

class AnimalsFilterToggleOption extends StatelessWidget {
  final String title;
  final bool isSelected;

  const AnimalsFilterToggleOption({
    super.key,
    required this.title,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 40,
        minWidth: 70,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: isSelected ? const Color(0xFFFAFAF9) : Colors.transparent,
      child: Text(title),
    );
  }
}
