import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';

class NotNullRequiredValidator extends TextFieldValidator {
  NotNullRequiredValidator({required String errorText}) : super(errorText);

  @override
  bool get ignoreEmptyValues => false;

  @override
  bool isValid(dynamic value) {
    return value != null;
  }

  @override
  String? call(dynamic value) {
    return isValid(value) ? null : errorText;
  }
}

class DefaultRequiredValidator extends RequiredValidator {
  DefaultRequiredValidator({super.errorText = 'Este campo é obrigatório.'});
}

class GreaterOrEqualThanDateValidator extends TextFieldValidator {
  final DateTime? beforeDate;
  final String? beforeDateLabel;

  GreaterOrEqualThanDateValidator({
    this.beforeDate,
    this.beforeDateLabel,
  }) : super(
            'A data deve ser maior ou igual a ${beforeDateLabel ?? beforeDate?.toString()}'); // Removemos o `errorText` dinâmico do construtor.

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(dynamic value) {
    try {
      if (value == null || beforeDate == null) {
        return true;
      }
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      return date.isAfter(beforeDate!) || date.isAtSameMomentAs(beforeDate!);
    } catch (_) {
      return false; // Retorna inválido se não conseguir parsear a data
    }
  }

  @override
  String? call(dynamic value) {
    return isValid(value)
        ? null
        : 'A data deve ser maior ou igual a ${beforeDateLabel ?? beforeDate?.toString()}';
  }
}

class LessThanDateValidator extends TextFieldValidator {
  final DateTime? afterDate;
  final String? afterDateLabel;

  LessThanDateValidator({
    this.afterDate,
    this.afterDateLabel,
  }) : super(
            'A data deve ser menor ou igual a ${afterDateLabel ?? afterDate?.toString()}'); // Removemos o `errorText` dinâmico do construtor.

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(dynamic value) {
    try {
      if (value == null || afterDate == null) {
        return true;
      }
      final date = DateFormat('dd/MM/yyyy').parseStrict(value);
      return date.isBefore(afterDate!) || date.isAtSameMomentAs(afterDate!);
    } catch (_) {
      return false; // Retorna inválido se não conseguir parsear a data
    }
  }

  @override
  String? call(dynamic value) {
    return isValid(value)
        ? null
        : 'A data deve ser menor ou igual a ${afterDateLabel ?? afterDate?.toString()}';
  }
}
