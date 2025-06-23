class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Simple email format validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigit = value.contains(RegExp(r'\d'));
    final hasSpecialCharacter = value.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );

    if (!hasUppercase || !hasLowercase || !hasDigit || !hasSpecialCharacter) {
      return 'Password must include a capital letter, a number, and a symbol';
    }
    return null;
  }
}
