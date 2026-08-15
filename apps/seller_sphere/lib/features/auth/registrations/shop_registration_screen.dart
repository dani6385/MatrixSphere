import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
import 'components/shop_registration_appbar.dart';
import 'components/shop_registration_body.dart';
import 'states/shop_registration_state.dart';
import 'logics/shop_registration_logic.dart';

class ShopRegistrationScreen extends StatefulWidget {
  const ShopRegistrationScreen({super.key});

  @override
  State<ShopRegistrationScreen> createState() => _ShopRegistrationScreenState();
}

class _ShopRegistrationScreenState extends State<ShopRegistrationScreen> {
  final ShopRegistrationLogic _logic = ShopRegistrationLogic();
  final ShopRegistrationState _state = ShopRegistrationState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        context.go(AppRoutes.login);
      },
      child: Scaffold(
        appBar: const ShopRegistrationAppBar(),
        body: ShopRegistrationBody(
          state: _state,
          logic: _logic,
          onUpdate: () {
            setState(() {
              // Cukup panggil setState untuk membangun ulang UI dengan state baru
            });
          },
        ),
      ),
    );
  }
}
