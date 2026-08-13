
/// Base class for all custom exceptions in the application.
abstract class AppException implements Exception {
  final String message;
  final String? details;

  AppException(this.message, {this.details});

  @override
  String toString() {
    if (details != null) {
      return 'AppException: $message (Details: $details)';
    }
    return 'AppException: $message';
  }
}

/// Exception thrown when a network request fails.
class NetworkException extends AppException {
  NetworkException(String message, {String? details})
      : super('Network Error: $message', details: details);
}

/// Exception thrown when an API call returns an error.
class ApiException extends AppException {
  final int? statusCode;

  ApiException(String message, {this.statusCode, String? details})
      : super('API Error: $message', details: details);

  @override
  String toString() {
    String statusInfo = statusCode != null ? ' (Status: $statusCode)' : '';
    return 'ApiException: $message$statusInfo' + (details != null ? ' (Details: $details)' : '');
  }
}

/// Exception thrown when data validation fails.
class ValidationException extends AppException {
  ValidationException(String message, {String? details})
      : super('Validation Error: $message', details: details);
}

/// Exception thrown for unexpected or unhandled errors.
class UnexpectedException extends AppException {
  UnexpectedException(String message, {String? details})
      : super('Unexpected Error: $message', details: details);
}

/// Exception thrown when a resource is not found.
class NotFoundException extends AppException {
  NotFoundException(String message, {String? details})
      : super('Not Found: $message', details: details);
}

/// Exception thrown when an operation is unauthorized.
class UnauthorizedException extends AppException {
  UnauthorizedException(String message, {String? details})
      : super('Unauthorized: $message', details: details);
}