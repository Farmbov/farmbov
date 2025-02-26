import 'package:flutter/material.dart';

import 'package:farmbov/src/presenter/features/dashboard/widgets/animals_filtter_toggle_option.dart';

class AnimalsFilterToggle extends StatefulWidget {
  const AnimalsFilterToggle({super.key});

  @override
  State<AnimalsFilterToggle> createState() => _AnimalsFilterToggleState();
}

class _AnimalsFilterToggleState extends State<AnimalsFilterToggle> {
  final List<bool> _selectedToggleOptions = <bool>[true, false, false];

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      direction: Axis.horizontal,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < _selectedToggleOptions.length; i++) {
            _selectedToggleOptions[i] = i == index;
          }
        });
      },
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      selectedColor: const Color(0xFF292524),
      fillColor: Colors.transparent,
      color: const Color(0xFFD7D3D0),
      constraints: const BoxConstraints(
        maxHeight: 40,
        minWidth: 70,
      ),
      splashColor: const Color(0xFF292524).withOpacity(0.05),
      isSelected: _selectedToggleOptions,
      children: <Widget>[
        AnimalsFilterToggleOption(
            title: 'Todos', isSelected: _selectedToggleOptions[0]),
        AnimalsFilterToggleOption(
            title: 'Lote verde', isSelected: _selectedToggleOptions[1]),
        AnimalsFilterToggleOption(
            title: 'Lote vermelho', isSelected: _selectedToggleOptions[2]),
      ],
    );
  }
}
