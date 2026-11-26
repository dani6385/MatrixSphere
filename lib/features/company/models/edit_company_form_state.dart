import 'package:flutter/material.dart';
import '../core/company_profile_constants.dart';
import 'company_profile_model.dart';

class CompanyFormState {
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

  CompanyFormState({
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
            TextEditingController(text: CompanyProfileConstants.defaultWorkStart),
        matrixEndController =
            TextEditingController(text: CompanyProfileConstants.defaultWorkEnd),
        latitudeController = TextEditingController(),
        longitudeController = TextEditingController(),
        radiusMetersController = TextEditingController(
          text: CompanyProfileConstants.defaultRadiusMeters,
        ),
        graceMinutesController = TextEditingController(
          text: CompanyProfileConstants.defaultGraceMinutesStr,
        ),
        overtimeScheduleTextController = TextEditingController(
          text: CompanyProfileConstants.defaultOvertimeScheduleText,
        ),
        decreeNumberController = TextEditingController(),
        decreeNoteController = TextEditingController(
          text: CompanyProfileConstants.defaultDecreeNote,
        ),
        weekdayOvertimeEndController = TextEditingController(
          text: CompanyProfileConstants.defaultWeekdayOvertimeEnd,
        ),
        saturdayStartController = TextEditingController(
          text: CompanyProfileConstants.defaultWeekendStart,
        ),
        saturdayEndController = TextEditingController(
          text: CompanyProfileConstants.defaultWeekendEnd,
        ),
        sundayStartController = TextEditingController(
          text: CompanyProfileConstants.defaultWeekendStart,
        ),
        sundayEndController = TextEditingController(
          text: CompanyProfileConstants.defaultWeekendEnd,
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
