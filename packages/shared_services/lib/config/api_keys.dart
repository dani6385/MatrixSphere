// shared_services/lib/config/api_keys.dart

class ApiKeys {
  ApiKeys._();

  /// API Key ImgBB (bisa diisi langsung atau lewat --dart-define=IMGBB_API_KEY=...)
  static const String imgbbApiKey = String.fromEnvironment(
    'IMGBB_API_KEY',
    defaultValue: 'f601727fed32cf7a175833d01d8a10ff',
  );
}