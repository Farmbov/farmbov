// Método genérico para construir um card de animal
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../domain/models/firestore/animal_model.dart';

class AnimalCard extends StatelessWidget {
  final String title;
  final AnimalModel? animal;
  final VoidCallback? onRemove;

  const AnimalCard(
      {super.key,
      required this.title,
      this.animal,
      this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFF518159), width: 0.3),
      ),
      child: Column(
        children: [
          // Cabeçalho do card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF9BB7A0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          ListTile(
            contentPadding: const EdgeInsets.all(10),
            title: Text('Brinco: ${animal?.tagNumber ?? '-'}'),
            subtitle: Text('Lote: ${animal?.lot ?? '-'}'),
            trailing: ResponsiveBreakpoints.of(context).isMobile
                ? IconButton(
                    tooltip: 'Alterar $title',
                    icon: Icon(Icons.close, color: onRemove != null?Colors.red:Colors.grey),
                    onPressed: onRemove,
                  )
                : TextButton(
                    onPressed: onRemove,
                    child: const Text('Alterar'),
                  ),
          ),
        ],
      ),
    );
  }
}
