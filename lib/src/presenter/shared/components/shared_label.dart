import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:flutter/material.dart';

class SharedLabel extends StatelessWidget {
  final bool selected;
  const SharedLabel({super.key, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Compartilhada',
        style: TextStyle(
          fontSize: 10,
          color: !selected ? AppColors.primaryGreen : Colors.white,
        ),
      ),
    );
  }
}
