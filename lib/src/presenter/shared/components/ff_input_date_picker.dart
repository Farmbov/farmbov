import 'package:intl/intl.dart';
import 'package:farmbov/src/presenter/shared/components/ff_input.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FFInputDatePicker extends StatefulWidget {
  final String labelText;
  final String floatingLabel;
  final Function(DateTime)? onSelectDate;
  final DateTime? initDate;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const FFInputDatePicker({
    super.key,
    required this.labelText,
    required this.floatingLabel,
    this.onSelectDate,
    this.initDate,
    this.readOnly = false,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<FFInputDatePicker> createState() => _FFInputDatePickerState();
}

class _FFInputDatePickerState extends State<FFInputDatePicker> {
  late TextEditingController _controller;
  DateTime? selectedDate;

  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initDate;
    _controller = TextEditingController();

    if (selectedDate != null) {
      _controller.text = DateFormat('dd/MM/yyyy').format(selectedDate!);
    }

    if (widget.readOnly) return;

    _controller.addListener(() {
      _handleTextChange(_controller.text);
    });
  }

  void _handleTextChange(String text) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(text);
      if (widget.onSelectDate != null) {
        widget.onSelectDate!(parsedDate);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _handleTextChange(_controller.text);
    });
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FFInput(
      floatingLabel: widget.floatingLabel,
      labelText: widget.labelText,
      controller: _controller,
      keyboardType: TextInputType.datetime,
      readOnly: widget.readOnly,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      sufixIcon: IconButton(
        onPressed: widget.readOnly
            ? null
            : () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                    _controller.text = DateFormat('dd/MM/yyyy').format(picked);
                  });

                  if (widget.onSelectDate != null) {
                    widget.onSelectDate!(picked);
                  }
                }
              },
        icon: const Icon(Icons.calendar_month_outlined),
      ),
      inputFormatters: [maskFormatter],
      validator: widget.validator,
    );
  }
}
