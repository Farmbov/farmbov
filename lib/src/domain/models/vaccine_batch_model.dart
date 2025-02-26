import 'package:cloud_firestore/cloud_firestore.dart';

class VaccineBatchModel {
  final String batchNumber;
  final DateTime manufactureDate;
  final DateTime expirationDate;
  final int initialQuantity;
  int availableQuantity;
  final String? storageLocation;
  final String? supplier;
  final bool active;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final DocumentReference? ref;

  VaccineBatchModel({
    required this.batchNumber,
    required this.manufactureDate,
    required this.expirationDate,
    required this.initialQuantity,
    required this.availableQuantity,
    required this.storageLocation,
    required this.supplier,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    this.ref,
  });

  // Construtor fromJson
  factory VaccineBatchModel.fromJson(
      Map<String, dynamic> json, DocumentReference ref) {
    return VaccineBatchModel(
      batchNumber: json['batch_number']??'',
      manufactureDate: (json['manufacture_date'] as Timestamp).toDate(),
      expirationDate: (json['expiration_date'] as Timestamp).toDate(),
      initialQuantity: json['initial_quantity'],
      availableQuantity: json['available_quantity'],
      storageLocation: json['storage_location'],
      supplier: json['supplier'],
      active: json['active'] as bool,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      ref: ref,
    );
  }

  // Construtor .empty
  factory VaccineBatchModel.empty() {
    return VaccineBatchModel(
      batchNumber: '',
      manufactureDate: DateTime.now(),
      expirationDate: DateTime.now(),
      initialQuantity: 0,
      availableQuantity: 0,
      storageLocation: '',
      supplier: '',
      active: true,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      ref: null,
    );
  }

  // Método toJson
  Map<String, dynamic> toJson() {
    return {
      'batch_number': batchNumber.toLowerCase(),
      'manufacture_date': manufactureDate,
      'expiration_date': expirationDate,
      'initial_quantity': initialQuantity,
      'available_quantity': availableQuantity,
      'storage_location': storageLocation,
      'supplier': supplier,
      'active': active,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Método copyWith
  VaccineBatchModel copyWith({
    String? batchNumber,
    DateTime? manufactureDate,
    DateTime? expirationDate,
    int? initialQuantity,
    int? availableQuantity,
    String? storageLocation,
    String? supplier,
    bool? active,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    DocumentReference? ref,
  }) {
    return VaccineBatchModel(
      batchNumber: batchNumber ?? this.batchNumber,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expirationDate: expirationDate ?? this.expirationDate,
      initialQuantity: initialQuantity ?? this.initialQuantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      storageLocation: storageLocation ?? this.storageLocation,
      supplier: supplier ?? this.supplier,
      active: active ?? this.active,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ref: ref ?? this.ref,
    );
  }
}
