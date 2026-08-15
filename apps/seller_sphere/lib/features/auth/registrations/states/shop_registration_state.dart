import 'package:flutter/material.dart';

class ShopRegistrationState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  void setIsLoading(bool loading) {
    isLoading = loading;
  }

  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
  }
}