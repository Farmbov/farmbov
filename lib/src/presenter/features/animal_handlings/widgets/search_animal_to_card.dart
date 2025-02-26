import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../../domain/models/firestore/animal_model.dart';
import '../../search_animal/search_animal_widget.dart';

class SearchAnimalToCard extends StatelessWidget {
  final String title;
  final TextEditingController searchController;
  final void Function(AnimalModel?) onAnimalSelected;
  final bool onlyMales;
  final bool onlyFemales;

  const SearchAnimalToCard({
    super.key,
    required this.title,
    required this.searchController,
    required this.onAnimalSelected,
    required this.onlyMales,
    required this.onlyFemales,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF44403C),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        SearchAnimalWidget(
          searchController: searchController,
          onAnimalSelected: onAnimalSelected,
          onlyMales: onlyMales,
          onlyFemales: onlyFemales,
        )
      ]);
    });
  }
}
