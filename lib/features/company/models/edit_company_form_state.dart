import 'package:flutter/material.dart';
import '../core/edit_company_constants.dart';
import 'company_profile_model.dart';

class EditCompanyFormState {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController descriptionController;
  final TextEditingController matrixStartController;
  final TextEditingController matrixEndController;
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final TextEditingController radiusMetersController;
  final TextEditingController graceMinutesController;
  final TextEditingController overtimeScheduleTextController;
  final TextEditingController decreeNumberController;
  final TextEditingController decreeNoteController;
  final TextEditingController weekdayOvertimeEndController;
  final TextEditingController saturdayStartController;
  final TextEditingController saturdayEndController;
  final TextEditingController sundayStartController;
  final TextEditingController sundayEndController;

  // true = Lembur Aktif, false = Pulang
  bool isOvertimeRequired;

  EditCompanyFormState({
    CompanyProfileModel? initialCompany,
    this.isOvertimeRequired = false,
  })  : nameController = TextEditingController(text: initialCompany?.name ?? ''),
        emailController =
            TextEditingController(text: initialCompany?.email ?? ''),
        phoneController =
            TextEditingController(text: initialCompany?.phone ?? ''),
        addressController =
            TextEditingController(text: initialCompany?.address ?? ''),
        descriptionController =
            TextEditingController(text: initialCompany?.description ?? ''),
        matrixStartController =
            TextEditingController(text: EditCompanyConstants.defaultWorkStart),
        matrixEndController =
            TextEditingController(text: EditCompanyConstants.defaultWorkEnd),
        latitudeController = TextEditingController(),
        longitudeController = TextEditingController(),
        radiusMetersController = TextEditingController(
          text: EditCompanyConstants.defaultRadiusMeters,
        ),
        graceMinutesController = TextEditingController(
          text: EditCompanyConstants.defaultGraceMinutes,
        ),
        overtimeScheduleTextController = TextEditingController(
          text: EditCompanyConstants.defaultOvertimeScheduleText,
        ),
        decreeNumberController = TextEditingController(),
        decreeNoteController = TextEditingController(
          text: EditCompanyConstants.defaultDecreeNote,
        ),
        weekdayOvertimeEndController = TextEditingController(
          text: EditCompanyConstants.defaultWeekdayOvertimeEnd,
        ),
        saturdayStartController = TextEditingController(
          text: EditCompanyConstants.defaultWeekendStart,
        ),
        saturdayEndController = TextEditingController(
          text: EditCompanyConstants.defaultWeekendEnd,
        ),
        sundayStartController = TextEditingController(
          text: EditCompanyConstants.defaultWeekendStart,
        ),
        sundayEndController = TextEditingController(
          text: EditCompanyConstants.defaultWeekendEnd,
        );

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    matrixStartController.dispose();
    matrixEndController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    radiusMetersController.dispose();
    graceMinutesController.dispose();
    overtimeScheduleTextController.dispose();
    decreeNumberController.dispose();
    decreeNoteController.dispose();
    weekdayOvertimeEndController.dispose();
    saturdayStartController.dispose();
    saturdayEndController.dispose();
    sundayStartController.dispose();
    sundayEndController.dispose();
  }
}
