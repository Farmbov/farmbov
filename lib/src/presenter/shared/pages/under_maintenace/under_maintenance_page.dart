import 'package:flutter/material.dart';

class UnderMaintenancePage extends StatelessWidget {
  const UnderMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Em desenvolvimento. Disponível nas próximas entregas.',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
