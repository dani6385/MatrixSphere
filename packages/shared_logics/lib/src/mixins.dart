
mixin LoggerMixin {
  void log(String message) {
    print('LoggerMixin: $message');
  }
  void logError(String message, [dynamic error, StackTrace? stackTrace]) {
    print('LoggerMixin Error: $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
  
}
