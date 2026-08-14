import 'package:flutter/material.dart';

/// Kelas untuk menampung state pada halaman pendaftaran (Registration)
class RegistrationState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  RegistrationState({
    required this.isLoading,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
  });

  /// Fungsi factory untuk membuat inisialisasi awal state dengan nilai default
  factory RegistrationState.initial() {
    return RegistrationState(
      isLoading: false,
      isPasswordVisible: false,
      isConfirmPasswordVisible: false,
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      formKey: GlobalKey<FormState>(),
    );
  }

  /// Fungsi pembantu untuk menyalin state saat terjadi perubahan (immutability helper)
  RegistrationState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      nameController: nameController,
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      formKey: formKey,
    );
  }
}