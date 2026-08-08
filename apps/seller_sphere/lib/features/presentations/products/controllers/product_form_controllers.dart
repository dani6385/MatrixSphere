// lib/features/products/presentation/controllers/product_form_controllers.dart

import 'package:flutter/material.dart';

class ProductFormControllers {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController skuController;
  late TextEditingController purchasePriceController;
  late TextEditingController itemCountController;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String?> skuValue = ValueNotifier<String?>(null);
  void init() {
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    skuController = TextEditingController();
    purchasePriceController = TextEditingController();
    itemCountController = TextEditingController();
  }

  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    skuController.dispose();
    purchasePriceController.dispose();
    itemCountController.dispose();
    isLoading.dispose();
    skuValue.dispose();
  }

  void descriptionComponentText(String text) {
    descriptionController.text = text;
  }

  void priceComponentText(String text) {
    priceController.text = text;
  }

  void skuComponentText(String text) {
    skuController.text = text;
    skuValue.value = text;
  }

  void purchasePriceComponentText(String text) {
    purchasePriceController.text = text;
  }

  void itemCountComponentText(String text) {
    itemCountController.text = text;
  }

  void nameComponentText(String text) {
    nameController.text = text;
  }
}
