
import 'package:flutter/material.dart';

class ShopRegistrationState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController shopAddressController = TextEditingController();

  bool isLoading = false;

  void dispose() {
    shopNameController.dispose();
    shopAddressController.dispose();
  }
}