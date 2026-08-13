
class CoreUtils {
  static void log(String message) {
    print('[CoreUtils] $message');
  }
  static bool get isDebugMode {
    return const bool.fromEnvironment('dart.vm.product') != true;
    
  }

  static bool get isReleaseMode {
    return const bool.fromEnvironment('dart.vm.product') == true;
  }
}
