/// Pure form-validation helpers, shared across features.
class Validators {
  Validators._();

  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    if (!_emailPattern.hasMatch(value.trim())) return 'Enter a valid email.';
    return null;
  }

  static String? password(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < minLength) {
      return 'Password must be at least $minLength characters.';
    }
    return null;
  }
}
