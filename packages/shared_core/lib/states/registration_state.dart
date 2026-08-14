import 'package:flutter/material.dart';

/// Kelas untuk menampung state pada halaman pendaftaran (UserRegistration)
class UserRegistrationState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;

  UserRegistrationState({
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
  factory UserRegistrationState.initial() {
    return UserRegistrationState(
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
  UserRegistrationState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return UserRegistrationState(
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

class ShopRegistrationState {
  final bool isLoading;
  final TextEditingController shopNameController;
  final TextEditingController descriptionController;
  final TextEditingController addressController;
  final GlobalKey<FormState> formKey;

  ShopRegistrationState({
    required this.isLoading,
    required this.shopNameController,
    required this.descriptionController,
    required this.addressController,
    required this.formKey,
  });

  /// Factory untuk inisialisasi awal state
  factory ShopRegistrationState.initial() {
    return ShopRegistrationState(
      isLoading: false,
      shopNameController: TextEditingController(),
      descriptionController: TextEditingController(),
      addressController: TextEditingController(),
      formKey: GlobalKey<FormState>(),
    );
  }

  /// Fungsi copyWith untuk memperbarui state secara aman
  ShopRegistrationState copyWith({
    bool? isLoading,
  }) {
    return ShopRegistrationState(
      isLoading: isLoading ?? this.isLoading,
      shopNameController: shopNameController,
      descriptionController: descriptionController,
      addressController: addressController,
      formKey: formKey,
    );
  }

  /// Fungsi untuk membersihkan memori controller saat tidak lagi digunakan
  void dispose() {
    shopNameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
  }
}