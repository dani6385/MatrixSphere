
library shared_logics;

class AppLogics {
  /// Validates if an email address is in a valid format.
  static bool isValidEmail(String email) {
    // Regular expression for email validation
    // This regex is a common one, but can be adjusted based on specific requirements.
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
  /// Validates if a password meets common security requirements.
  /// Requirements:/// - Minimum 8 characters
/// - At least one uppercase letter
/// - At least one lowercase letter
/// - At least one digit
/// - At least one special character (e.g., !@#$%^&*()-_+=)
  static bool isValidPassword(String password) {
    // Minimum 8 characters
    if (password.length < 8) {
      return false;
    }
    // At least one uppercase letter
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return false;
    }
    // At least one lowercase letter
    if (!password.contains(RegExp(r'[a-z]'))) {
      return false;
    }
    // At least one digit
    if (!password.contains(RegExp(r'[0-9]'))) {
      return false;
    }
    // At least one special character
    if (!password.contains(RegExp(r'[!@#$%^&*()-_+=]'))) {
      return false;
    }
    return true;
  }
}