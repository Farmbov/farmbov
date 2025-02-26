import 'package:built_value/built_value.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

abstract class BaseModel {
  @Default(true)
  bool get active;
  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;
  @BuiltValueField(wireName: 'updated_at')
  DateTime? get updatedAt;
  Map<String, dynamic>? toMap();
}
