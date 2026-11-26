import 'package:flutter/material.dart';

import '../form/company_profile_fields_form.dart';
import '../form/location_radius_form.dart';
import '../form/work_overtime_form_card.dart';
import '../logics/company_profile_controller.dart';
import '../widgets/admin_notice_banner.dart';
import '../widgets/save_company_button.dart';

class CompanyAppBody extends StatelessWidget {
  final CompanyController controller;
  final VoidCallback onSave;

  const CompanyAppBody({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final bool canEdit = controller.isAdmin && !controller.isSaving;

    return Form(
      key: controller.formState.formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AdminNoticeBanner(isAdmin: controller.isAdmin),
          CompanyProfileFieldsForm(
            formState: controller.formState,
            isAdmin: controller.isAdmin,
          ),
          const SizedBox(height: 24),
          WorkAndOvertimeForm(
            formState: controller.formState,
            isAdmin: controller.isAdmin,
            onOvertimeChanged: controller.setOvertimeRequired, canEdit: null,
          ),
          const SizedBox(height: 24),
          LocationRadiusForm(
            formState: controller.formState,
            isAdmin: controller.isAdmin,
          ),
          const SizedBox(height: 24),
          SaveCompanyButton(
            enabled: canEdit,
            isSaving: controller.isSaving,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}