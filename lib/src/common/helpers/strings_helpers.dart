import 'package:intl/intl.dart';

class StringHelpers {
  static String obscureCPF(String cpf) {
    // Limpa o CPF removendo caracteres não numéricos
    final cleanedCPF = cpf.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF é válido
    if (!_isValidCPF(cleanedCPF)) return cpf;

    // Ofusca o CPF mantendo apenas os três primeiros e os dois últimos dígitos visíveis
    final obscuredCPF = '${cleanedCPF.substring(0, 3)}'
        '.${cleanedCPF.substring(3, 6).replaceAll(RegExp(r'\d'), '*')}'
        '.${cleanedCPF.substring(6, 9).replaceAll(RegExp(r'\d'), '*')}'
        '-${cleanedCPF.substring(9)}';

    return obscuredCPF;
  }

  static String formatCPF(String cpf) {
    // Limpa o CPF removendo caracteres não numéricos
    final cleanedCPF = cpf.replaceAll(RegExp(r'\D'), '');

    // Verifica se o CPF tem 11 dígitos
    if (cleanedCPF.length != 11) return cpf;

    // Formata o CPF no formato XXX.XXX.XXX-XX
    return '${cleanedCPF.substring(0, 3)}'
        '.${cleanedCPF.substring(3, 6)}'
        '.${cleanedCPF.substring(6, 9)}'
        '-${cleanedCPF.substring(9)}';
  }

  static double? tryParseNumber(String value) {
    try {
      return NumberFormat.currency(locale: 'pt_BR').parse(value).toDouble();
    } catch (_) {
      return null;
    }
  }

  static String animalsAmountLabel(int amount) {
    return amount == 1 ? '1 animal' : '$amount animais';
  }

  // Função para validar CPF
  static bool _isValidCPF(String cpf) {
    if (cpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;

    // Calcula os dígitos verificadores
    List<int> digits = cpf.split('').map((d) => int.parse(d)).toList();

    // Valida o primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += digits[i] * (10 - i);
    }
    int firstVerifier = (sum * 10) % 11;
    if (firstVerifier == 10) firstVerifier = 0;
    if (digits[9] != firstVerifier) return false;

    // Valida o segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i] * (11 - i);
    }
    int secondVerifier = (sum * 10) % 11;
    if (secondVerifier == 10) secondVerifier = 0;
    return digits[10] == secondVerifier;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension StringExtensions on String {
  String capitalizeEachWord() {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }
}
