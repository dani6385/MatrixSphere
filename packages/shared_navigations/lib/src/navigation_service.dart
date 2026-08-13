
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
class NavigationService {
  final GoRouter _router;

  NavigationService(this._router);

  void go(String path, {Object? extra}) {
    _router.go(path, extra: extra);
  }

  void push(String path, {Object? extra}) {
    _router.push(path, extra: extra);
  }

  void pop() {
    if (_router.canPop()) {
      _router.pop();
    }
  }

  // Specific navigation methods for each route
  void goToLogin() => go(AppRoutes.login);
  void pushToLogin() => push(AppRoutes.login);

  void goToUserRegistration() => go(AppRoutes.userRegistration);
  void pushToUserRegistration() => push(AppRoutes.userRegistration);

  void goToForgotPassword() => go(AppRoutes.forgotPassword);
  void pushToForgotPassword() => push(AppRoutes.forgotPassword);

  void goToShopRegistration() => go(AppRoutes.shopRegistration);
  void pushToShopRegistration() => push(AppRoutes.shopRegistration);

  void goToMap() => go(AppRoutes.map);
  void pushToMap() => push(AppRoutes.map);
  void goToUserProfile() => go(AppRoutes.userProfile);
  void pushToUserProfile() => push(AppRoutes.userProfile);

  void goToShopProfile() => go(AppRoutes.shopProfile);
  void pushToShopProfile() => push(AppRoutes.shopProfile);

  void goToOrder() => go(AppRoutes.order);
  void pushToOrder() => push(AppRoutes.order);

  void goToProducts() => go(AppRoutes.products);
  void pushToProducts() => push(AppRoutes.products);

  void goToScanQr() => go(AppRoutes.scanQr);
  void pushToScanQr() => push(AppRoutes.scanQr);

  void goToSimulasi() => go(AppRoutes.simulasi);
  void pushToSimulasi() => push(AppRoutes.simulasi);

  void goToAbout() => go(AppRoutes.about);
  void pushToAbout() => push(AppRoutes.about);

  void goToHelp() => go(AppRoutes.help);
  void pushToHelp() => push(AppRoutes.help);

  void goToChat() => go(AppRoutes.chat);
  void pushToChat() => push(AppRoutes.chat);

  void goToStream() => go(AppRoutes.stream);
  void pushToStream() => push(AppRoutes.stream);
}
