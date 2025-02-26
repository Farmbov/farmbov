import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/providers/app_manager.dart';
import '../models/animal_down_reason_model.dart';

Future<List<AnimalDownReasonModel>> getAnimalDownReasons(
    BuildContext context) async {
  final currentFarm =
      Provider.of<AppManager>(context, listen: false).currentUser.currentFarm;

  final firebaseInstance = FirebaseFirestore.instance;
  final animalsDownReasons = await firebaseInstance
      .collection('farms')
      .doc(currentFarm?.id)
      .collection('animal_down_reasons')
      .get();

  List<AnimalDownReasonModel> listAnimalsDownReasons =
      animalsDownReasons.docs.map(
    (downReason) {
      return AnimalDownReasonModel(
          ref: downReason.id,
          name: downReason.data()['reason'],
          isActive: downReason.data()['is_active']);
    },
  ).toList();
  return listAnimalsDownReasons;
}
