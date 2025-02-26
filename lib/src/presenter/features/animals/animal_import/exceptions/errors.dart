// Formatação de data para o formato dia/mês/ano
import 'package:intl/intl.dart';

final dateFormatter = DateFormat('dd/MM/yyyy');

class AnimalImportValidationError implements Exception {
  final String message;
  AnimalImportValidationError(this.message);

  @override
  String toString() => 'AnimalImportValidationError: $message';
}

// Erro para quando a data de entrada for anterior à data de nascimento
class EntryDateBeforeBirthDateError extends AnimalImportValidationError {
  EntryDateBeforeBirthDateError(
      int fieldIndex, DateTime entryDate, DateTime birthDate)
      : super(
            '[Linha $fieldIndex] A data de entrada (${dateFormatter.format(entryDate)}) não pode ser anterior à data de nascimento (${dateFormatter.format(birthDate)}).');
}

// Erro para quando a data de pesagem for anterior à data de nascimento
class WeighingDateBeforeBirthDateError extends AnimalImportValidationError {
  WeighingDateBeforeBirthDateError(
      int fieldIndex, DateTime weighingDate, DateTime birthDate)
      : super(
            '[Linha $fieldIndex] A data de pesagem (${dateFormatter.format(weighingDate)}) não pode ser anterior à data de nascimento (${dateFormatter.format(birthDate)}).');
}

// Erro para quando a data de pesagem for anterior à data de entrada
class WeighingDateBeforeEntryDateError extends AnimalImportValidationError {
  WeighingDateBeforeEntryDateError(
      int fieldIndex, DateTime weighingDate, DateTime entryDate)
      : super(
            '[Linha $fieldIndex] A data de pesagem (${dateFormatter.format(weighingDate)})não pode ser anterior à data de entrada (${dateFormatter.format(entryDate)}).');
}
