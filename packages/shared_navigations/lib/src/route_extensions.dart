
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
extension GoRouterExtension on BuildContext {
  /// Navigates to a named route.
  ///
  /// The [name] is the name of the route to navigate to.
  /// The [pathParameters] are the path parameters for the route.
  /// The [queryParameters] are the query parameters for the route.
  /// The [extra] is an optional object that can be passed to the route.
  void goNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
  }) {
    GoRouter.of(this).goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pushes a named route onto the navigation stack.
  ///
  /// The [name] is the name of the route to push.
  /// The [pathParameters] are the path parameters for the route.
  /// The [queryParameters] are the query parameters for the route.
  /// The [extra] is an optional object that can be passed to the route.
  Future<T?> pushNamed<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
  }) {
    return GoRouter.of(this).pushNamed<T>(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Replaces the current route with a named route.
  ///
  /// The [name] is the name of the route to replace with.
  /// The [pathParameters] are the path parameters for the route.
  /// The [queryParameters] are the query parameters for the route.
  /// The [extra] is an optional object that can be passed to the route.
  void replaceNamed(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
  }) {
    GoRouter.of(this).replaceNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  /// Pops the current route off the navigation stack.
  void pop<T extends Object?>([T? result]) {
    GoRouter.of(this).pop(result);
  }
}
