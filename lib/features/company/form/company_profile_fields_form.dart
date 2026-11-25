import 'package:flutter/material.dart';
import '../models/edit_company_form_state.dart';

class CompanyProfileFieldsForm extends StatelessWidget {
  final EditCompanyFormState formState;
  final bool isAdmin;

  const CompanyProfileFieldsForm({
    super.key,
    required this.formState,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: formState.emailController,
          readOnly: !isAdmin,
          decoration: const InputDecoration(labelText: 'Email'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: formState.phoneController,
          readOnly: !isAdmin,
          decoration: const InputDecoration(labelText: 'Telepon'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: formState.addressController,
          readOnly: !isAdmin,
          decoration: const InputDecoration(labelText: 'Alamat'),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: formState.descriptionController,
          readOnly: !isAdmin,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Deskripsi'),
        ),
      ],
    );
  }
}