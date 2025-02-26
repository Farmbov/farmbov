// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:farmbov/src/domain/models/animal_breed_model.dart';

// import '../models/animal_down_reason_model.dart';
// import '../models/drug_administration_type.dart';

// Future<List<AnimalBreedModel>> getDefaultAnimalBreeds() async {
//   final snapshot = await FirebaseFirestore.instance
//       .collection('configurations')
//       .doc('app_default_values')
//       .collection('animal_breeds')
//       .get();

//   return snapshot.docs
//       .map((doc) => AnimalBreedModel(
//           name: doc.data()['breed'] as String,
//           isActive: doc.data()['is_active'] as bool))
//       .toList();
// }

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/animal_down_reason_model.dart';

Future<List<AnimalDownReasonModel>> getDefaultAnimalDownReasons() async {
  final snapshot = await FirebaseFirestore.instance
      .collection('configurations')
      .doc('app_default_values')
      .collection('animal_down_reasons')
      .get();

  return snapshot.docs
      .map((doc) => AnimalDownReasonModel(
          ref: doc.data()['id'],
          name: doc.data()['reason'] as String,
          isActive: doc.data()['is_active'] as bool))
      .toList();
}

// Future<List<DrugAdministrationType>> getDefaultDrugAdministrationTypes() async {
//   final snapshot = await FirebaseFirestore.instance
//       .collection('configurations')
//       .doc('app_default_values')
//       .collection('drug_administration_types')
//       .get();

//   return snapshot.docs
//       .map((doc) => DrugAdministrationType(
//           name: doc.data()['type'] as String,
//           isActive: doc.data()['is_active'] as bool))
//       .toList();
// }
