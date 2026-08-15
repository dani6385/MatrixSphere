
import 'package:shared_contents/shared_contents.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RouteGuard {
  Future<bool> canActivate();
}

class AuthGuard implements RouteGuard {
  @override
  Future<bool> canActivate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userToken = prefs.getString(KeyConstants.userToken);
    return userToken != null && userToken.isNotEmpty;
  }
}