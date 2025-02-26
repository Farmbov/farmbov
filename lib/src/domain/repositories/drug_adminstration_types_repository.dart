import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/drug_administration_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/providers/app_manager.dart';

Future<List<DrugAdministrationType>> getDrugAdministrationTypes(
    BuildContext context) async {
  final currentFarm =
      Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;

  final firebaseInstance = FirebaseFirestore.instance;
  final administrationTypes = await firebaseInstance
      .collection('farms')
      .doc(currentFarm?.id)
      .collection('drug_administration_types')
      .get();

  List<DrugAdministrationType> listAdministrationTypes =
      administrationTypes.docs.map(
    (drugAdmType) {
      return DrugAdministrationType(
          ref: drugAdmType.reference,
          name: drugAdmType.data()['type'],
          isActive: drugAdmType.data()['is_active']);
    },
  ).toList();
  return listAdministrationTypes;
}
