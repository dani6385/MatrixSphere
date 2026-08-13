
library shared_logics.utils;

/// A collection of shared utility functions and helpers.
class SharedUtils {
  /// Prints a message to the console, prefixed for identification.
  static void log(String message) {
    // In a real application, this might integrate with a more robust logging solution.
    print('[SharedUtils] $message');
  }

  /// Returns true if the provided string is null or empty.
  static bool isNullOrEmpty(String? s) {
    return s == null || s.isEmpty;
  }

  /// Returns true if the provided list is null or empty.
  static bool isListNullOrEmpty<T>(List<T>? list) {
    return list == null || list.isEmpty;
  }
}