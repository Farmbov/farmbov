import 'package:cloud_firestore/cloud_firestore.dart';

class VaccineModel {
  final String? name;
  final String? description;
  final int? dosesRequired;
  final int? intervalBetweenDosesInDays;
  final String? drugAdministrationType;
  final String? storageConditions;
  final int? quantity;
  final bool? isActive;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final DocumentReference? ref;

  VaccineModel({
    required this.name,
    required this.description,
    required this.dosesRequired,
    required this.intervalBetweenDosesInDays,
    required this.drugAdministrationType,
    required this.storageConditions,
    this.quantity,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.ref,
  });

  factory VaccineModel.fromJson(
      Map<String, dynamic> json, DocumentReference ref,
      {int? quantity}) {
    return VaccineModel(
      name: toTitleCase(json['name'] ??''),
      description: json['description'],
      dosesRequired: json['doses_required'],
      intervalBetweenDosesInDays: json['interval_between_doses_in_days'],
      drugAdministrationType: json['drug_administration_type'],
      storageConditions: json['storage_conditions'],
      quantity: quantity ?? 0,
      isActive: json['active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ref: ref,
    );
  }

  factory VaccineModel.empty() {
    return VaccineModel(
        name: '',
        description: '',
        dosesRequired: 0,
        intervalBetweenDosesInDays: 0,
        drugAdministrationType: null,
        storageConditions: '',
        isActive: false,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        ref: null);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name?.toLowerCase(),
      'description': description,
      'doses_required': dosesRequired,
      'interval_between_doses_in_days': intervalBetweenDosesInDays,
      'drug_administration_type': drugAdministrationType,
      'storage_conditions': storageConditions,
      'active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  VaccineModel copyWith({
    String? name,
    String? description,
    int? dosesRequired,
    int? intervalBetweenDosesInDays,
    String? drugAdministrationType,
    String? storageConditions,
    bool? isActive,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    DocumentReference? ref,
  }) {
    return VaccineModel(
      name: name ?? this.name,
      description: description ?? this.description,
      dosesRequired: dosesRequired ?? this.dosesRequired,
      intervalBetweenDosesInDays:
          intervalBetweenDosesInDays ?? this.intervalBetweenDosesInDays,
      drugAdministrationType:
          drugAdministrationType ?? this.drugAdministrationType,
      storageConditions: storageConditions ?? this.storageConditions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ref: ref ?? this.ref,
    );
  }
}


//TODO: Criar uma extension
String toTitleCase(String text) {
  if (text.isEmpty) return text;

  return text
      .split(' ') // Divide a string em palavras
      .map((word) {
        if (word.isEmpty) return word; // Evita erros em palavras vazias
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      })
      .join(' '); // Junta as palavras novamente em uma única string
}