import 'package:cached_network_image/cached_network_image.dart';
import 'package:farmbov/src/domain/services/domain/animal_data_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'package:farmbov/src/common/providers/navigation_service.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/common/themes/farm_bov_icons.dart';
import 'package:farmbov/src/domain/models/firestore/animal_model.dart';

class SearchAnimalWidget extends StatefulWidget {
  final void Function(AnimalModel)? onAnimalSelected;
  final bool onlyActive;
  final bool onlyFemales;
  final bool onlyMales;
  final TextEditingController? searchController;
  const SearchAnimalWidget({
    super.key,
    this.onAnimalSelected,
    this.onlyActive = true,
    this.onlyFemales = false,
    this.onlyMales = false,
    this.searchController,
  });

  @override
  State<SearchAnimalWidget> createState() => _SearchAnimalWidgetState();
}

class _SearchAnimalWidgetState extends State<SearchAnimalWidget> {
  final AnimalDataService _animalDataService = AnimalDataService();

  @override
  void initState() {
    widget.searchController?.text = '';
    super.initState();
  }

  Widget _defaultAvatar() {
    return const CircleAvatar(
      backgroundColor: Colors.black12,
      child: Icon(
        FarmBovIcons.cow,
        size: 24,
        color: Colors.black54,
      ),
    );
  }

  Widget _buildTileSubtitle(String? sex, double? weight, DateTime? birthDate) {
    String template = '';

    if (sex != null) {
      template += ' Sexo: $sex';
    }
    if (weight != null) {
      template += ' - Peso: ${weight.toStringAsFixed(2)}kg';
    }
    if (birthDate != null) {
      template +=
          ' - Nascimento: ${DateFormat('dd/MM/yyyy').format(birthDate)}';
    }
    return Text(template);
  }

  Widget _buildTile(BuildContext context, AnimalModel animal) {
    return ListTile(
      onTap: widget.onAnimalSelected != null
          ? null
          : () => context.pushNamedAuth( 
                RouteName.animalVisualize,
                mounted,
                ignoreRedirect: true,
                params: {"id": animal.ffRef?.id ?? '-1'},
                extra: {"model": animal},
              ),
      leading: (animal.photoUrl?.isEmpty ?? true)
          ? _defaultAvatar()
          : CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                animal.photoUrl!,
              ),
              backgroundColor: Colors.black12,
              child: _defaultAvatar(),
            ),
      title: Text(animal.tagNumber ?? 'Sem tag'),
      subtitle: _buildTileSubtitle(animal.sex, animal.weight, animal.birthDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<AnimalModel>(
      suggestionsCallback: (pattern) async {
        if (pattern.length <= 2) return [];

        return _animalDataService.listAnimals(
            searchTerm: pattern,
            isActive: widget.onlyActive,
            onlyFemales: widget.onlyFemales,
            onlyMales: widget.onlyMales);
      },
      itemBuilder: (context, suggestion) => _buildTile(context, suggestion),
      emptyBuilder: (
        context,
      ) =>
          Padding(
        padding: const EdgeInsets.all(12),
        child: widget.searchController!.text.length <= 2
            ? const Text('Digite ao menos 3 caracteres para buscar.')
            : const Text('Nenhum animal encontrado'),
      ),
      onSelected: widget.onAnimalSelected ?? (animal) => {},
      controller: widget.searchController,
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            label: Text(
              'Buscar animal',
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFF79716B),
            ),
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF79716B),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffD7D3D0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }
}
