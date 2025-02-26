// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GlobalFarmModel {
  final String? id;
  final String? name;
  final String? userId;

  GlobalFarmModel({
    required this.id,
    required this.name,
    required this.userId,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GlobalFarmModel &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'userId': userId,
    };
  }

  factory GlobalFarmModel.fromMap(Map<String, dynamic> map) {
    return GlobalFarmModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GlobalFarmModel.fromJson(String source) =>
      GlobalFarmModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
