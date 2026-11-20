import 'package:flutter/material.dart';

import 'login_appbar.dart';
import 'login_body.dart';
import 'login_logic.dart';

/// Kerangka layar utama Login yang menggabungkan `LoginAppBar`, `LoginBody`,
/// dan `LoginLogic`.
class LoginScreen extends StatefulWidget {
  /// `true` untuk Matrix Sphere (hanya login), `false` untuk anak aplikasi.
  final bool isMatrixSphere;
  final bool enableShopRegistration;
  final bool showAppBar;

  const LoginScreen({
    super.key,
    this.isMatrixSphere = true,
    this.enableShopRegistration = true,
    this.showAppBar = false,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginLogic<LoginScreen> {
  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  @override
  void dispose() {
    disposeLoginControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? const LoginAppBar() : null,
      body: LoginBody(
        formKey: formKey,
        emailController: emailController,
        passwordController: passwordController,
        isPasswordObscured: isPasswordObscured,
        isLoading: isLoading,
        rememberMe: rememberMe,
        isMatrixSphere: widget.isMatrixSphere,
        enableShopRegistration: widget.enableShopRegistration,
        onTogglePasswordVisibility: togglePasswordVisibility,
        onRememberMeChanged: updateRememberMe,
        onSubmitLogin: submitLogin,
      ),
    );
  }
}