
import 'package:flutter/material.dart';

class AnimalSituationLabel extends StatelessWidget {
  final bool active;
  const AnimalSituationLabel({
    super.key,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: active ? const Color(0xFFF3FEE7) : const Color(0xFFFEF3F2),
      ),
      child: Text(
        active ? 'Ativo' : 'Baixado',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 12,
              color: active ? const Color(0xFF3B7C0F) : const Color(0xFFB42318),
            ),
      ),
    );
  }
}
