import 'package:farmbov/src/domain/models/animal_down_reason_model.dart';

enum AnimalDownReasonEnum {
  sale,
  death,
  disappearance,
  incorrectEntry,
  other,
}

final Map<AnimalDownReasonEnum, AnimalDownReasonModel>
    defaultAnimalDownReasons = {
  AnimalDownReasonEnum.sale: AnimalDownReasonModel(name: 'Venda'),
  AnimalDownReasonEnum.death: AnimalDownReasonModel(name: 'Morte'),
  AnimalDownReasonEnum.disappearance:
      AnimalDownReasonModel(name: 'Desaparecimento'),
  AnimalDownReasonEnum.incorrectEntry:
      AnimalDownReasonModel(name: 'Lançamento indevido'),
  AnimalDownReasonEnum.other: AnimalDownReasonModel(name: 'Outros'),
};

//TODO: Remover o dd
final List<AnimalDownReasonModel> ddefaultAnimalDownReasons = [
  AnimalDownReasonModel(name: "Venda"),
  AnimalDownReasonModel(name: 'Morte'),
  AnimalDownReasonModel(name: 'Desaparecimento'),
  AnimalDownReasonModel(name: 'Lançamento indevido'),
  AnimalDownReasonModel(name: 'Outros'),
];
