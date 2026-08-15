
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initial = '/';
  static const String login = '/login';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        initial: (context) => const Scaffold(body: Center(child: Text('Initial'))),
        login: (context) => const Scaffold(body: Center(child: Text('Login'))),
        home: (context) => const Scaffold(body: Center(child: Text('home'))),
      };
}