// lib/screens/login/widgets/login_body.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/navigations/app_routes.dart';
//import 'login_header.dart';
import 'login_form_fields.dart';

class LoginBody extends StatelessWidget {
  final VoidCallback onLogin; // Changed from onLoginPressed
  final LoginFormFields formFields; // Keep this as LoginFormFields

  const LoginBody({
    super.key,
    required this.onLogin, // Changed from onLoginPressed
    required this.formFields,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: AutofillGroup(
          child: Form(
            key: formFields.formKey, // Access formKey from formFields
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //const LoginHeader(),
                const SizedBox(height: 40),
                formFields, // Use the passed formFields widget directly
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print('Lupa Password!');
                      }
                      context.go(AppRoutes.forgotPassword);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: onLogin, // Use the onLogin callback
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
