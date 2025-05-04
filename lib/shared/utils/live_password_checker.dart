import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordValidationProvider = StateProvider<PasswordValidation>((ref) {
  return PasswordValidation.fromPassword('');
});

class PasswordValidation {
  final bool hasMinLength;
  final bool hasSpecialChar;

  PasswordValidation(
      {required this.hasMinLength, required this.hasSpecialChar});

  bool get isPasswordValid => hasMinLength && hasSpecialChar;

  factory PasswordValidation.fromPassword(String input) {
    return PasswordValidation(
      hasMinLength: input.length >= 8,
      hasSpecialChar: RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(input),
    );
  }
}
