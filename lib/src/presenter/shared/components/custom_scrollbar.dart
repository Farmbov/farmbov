import 'package:flutter/material.dart';

class CustomSingleChildScrollView extends StatelessWidget {
  final Widget child;

  const CustomSingleChildScrollView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    return Scrollbar(
      thumbVisibility: true,
      thickness: 10,
      controller: scrollController,
      // thumbColor: MaterialStateProperty.all<Color>(Colors.blue), // Customize the scrollbar thumb color
      // trackColor: MaterialStateProperty.all<Color>(Colors.grey), // Customize the scrollbar track color
      // trackBorderColor: MaterialStateProperty.all<Color>(Colors.transparent), // Customize the scrollbar track border color
      child: SingleChildScrollView(
        controller: scrollController,
        child: child,
      ),
    );
  }
}
