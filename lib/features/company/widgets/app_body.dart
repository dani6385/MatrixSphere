import 'package:flutter/material.dart';

import '../form/company_profile_fields_form.dart';
import '../form/location_radius_form.dart';
import '../form/work_and_overtime_form.dart';
import '../logics/edit_company_controller.dart';
import '../widgets/admin_notice_banner.dart';
import '../widgets/save_company_button.dart';

class EditCompanyAppBody extends StatelessWidget {
  final EditCompanyController controller;
  final VoidCallback onSave;

  const EditCompanyAppBody({
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
            onOvertimeChanged: controller.setOvertimeRequired,
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