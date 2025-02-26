// ignore_for_file: use_build_context_synchronously

import 'package:farmbov/src/common/providers/alert_manager.dart';
import 'package:farmbov/src/common/router/route_name.dart';
import 'package:farmbov/src/domain/extensions/backend.dart';
import 'package:farmbov/src/domain/models/firestore/animal_breed_model.dart';
import 'package:flutter/material.dart';

import 'package:farmbov/src/common/themes/theme_constants.dart';
import 'package:farmbov/src/domain/stores/common_base_store.dart';
import 'package:farmbov/src/presenter/shared/components/ff_button.dart';
import 'package:farmbov/src/presenter/shared/modals/base_alert_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../common/providers/app_manager.dart';

class AnimalsBreedsPageStore extends CommonBaseStore<List<AnimalBreedModel>> {
  AnimalsBreedsPageStore() : super([]);

  final breedNameController = TextEditingController();
  void addBreed(BuildContext context) async {
    final currentFarm =
        Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;
    try {
      setLoading(true);

      if (currentFarm?.name == null) {
        throw Exception('Usuário sem fazenda!');
      }

      if (breedNameController.text.isEmpty) {
        throw Exception('Preencha o nome da raça');
      }

      final existingBreed = await getAnimalsBreeds(
        queryBuilder: (breed) =>
            breed.where('name', isEqualTo: breedNameController.text),
      );

      if (existingBreed.data.isNotEmpty) {
        AlertManager.showToast(
            'Raça já cadastrada, tente novamente com outro nome.');
        return setLoading(false);
      }

      final model =
          createAnimalBreedModel(name: breedNameController.text.trim());
      await AnimalBreedModel.collection.doc().set(model);

      showInsertSuccessModal(
        context,
      );

      update([], force: true);
    } catch (e) {
      if (currentFarm?.name == null) {
        AlertManager.showToast(
          'Crie uma fazenda antes de cadastrar raças!',
        );
      } else if (breedNameController.text.isEmpty) {
        AlertManager.showToast(
          'Insira o nome de uma raça',
        );
      } else {
        AlertManager.showToast(
            'Erro ao adicionar raça, tente novamente mais tarde.');
      }
    } finally {
      setLoading(false);
    }
  }

  void showInsertSuccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return BaseAlertModal(
          title: 'Raça adicionada com sucesso!',
          actionCallback: () => context.pop(),
          showCancel: false,
        );
      },
    );
  }

  void deleteBreed(
    BuildContext context, {
    AnimalBreedModel? model,
  }) async {
    showDialog(
      context: context,
      builder: (_) => BaseAlertModal(
        title: 'Tem certeza que deseja excluir essa raça?',
        type: BaseModalType.danger,
        actionWidgets: [
          FFButton(
            text: 'Excluir raça',
            onPressed: () async {
              try {
                var ffRef = model?.ffRef;
                await ffRef?.delete();

                showDialog(
                  context: context,
                  builder: (_) => const BaseAlertModal(
                    title: 'Raça excluída com sucesso!',
                    popScopePageRoute: RouteName.animalBreeds,
                    showCancel: false,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Erro ao excluir raça'),
                  ),
                );
              }
            },
            backgroundColor: AppColors.feedbackDanger,
            borderColor: AppColors.feedbackDanger,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          FFButton(
            text: 'Cancelar',
            onPressed: () => context.pop(),
            backgroundColor: Colors.transparent,
            borderColor: AppColors.feedbackDanger,
            textColor: AppColors.feedbackDanger,
            splashColor: AppColors.feedbackDanger.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
