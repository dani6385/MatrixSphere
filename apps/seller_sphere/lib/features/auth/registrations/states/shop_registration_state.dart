import 'package:flutter/material.dart';

class ShopRegistrationState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();
  final TextEditingController shopPhoneController = TextEditingController();
  final TextEditingController shopDescriptionController = TextEditingController();
  
  bool isLoading = false;

  void dispose() {
    shopNameController.dispose();
    shopAddressController.dispose();
    shopPhoneController.dispose();
    shopDescriptionController.dispose();
  }
}