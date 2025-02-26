import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DrugAdministrationType {
  DocumentReference? ref;
  late String name;
  late bool isActive;
  DrugAdministrationType(
      {required this.name, required this.isActive, this.ref});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': name,
      'is_active': isActive,
    };
  }

  factory DrugAdministrationType.fromMap(
      Map<String, dynamic> map, DocumentReference ref) {
    return DrugAdministrationType(
        ref: ref,
        name: map['type'] as String,
        isActive: map['is_active'] as bool);
  }

  String toJson() => json.encode(toMap());
}
