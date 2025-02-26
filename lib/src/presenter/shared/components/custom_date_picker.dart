import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/themes/theme_constants.dart';

class CustomDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? initialDate;
  final Function(DateTime) onDateSelected;
  final bool readOnly;

  const CustomDatePicker({
    super.key,
    required this.labelText,
    this.initialDate,
    required this.onDateSelected,
    this.readOnly = false,
  });

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(4000),
    );

    if (pickedDate != null) {
      onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => !readOnly ? _pickDate(context) : null,
      child: InputDecorator(
        decoration: const InputDecoration(
          suffixIcon: Icon(
            Icons.calendar_month_outlined,
            color: AppColors.primaryGreen,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0.3, color: AppColors.lightGray),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
        ),
        child: Text(
          initialDate != null
              ? DateFormat('dd/MM/yyyy').format(initialDate!)
              : labelText,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: initialDate != null ? Colors.black : Colors.grey.shade600,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ),
      ),
    );
  }
}
