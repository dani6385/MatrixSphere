import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';

import '../core/edit_company_constants.dart';

class EditCompanyService {
  EditCompanyService._();

  static Future<bool> checkIsAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    if (user.uid == EditCompanyConstants.permanentAdminUid) return true;

    final IdTokenResult tokenResult = await user.getIdTokenResult(true);
    final Map<String, dynamic>? claims = tokenResult.claims;
    return claims?['admin'] == true || claims?['isAdmin'] == true;
  }

  static Future<Map<dynamic, dynamic>?> loadCompanyProfileMap() async {
    final DataSnapshot snapshot = await rtdbService.getSnapshot(
      EditCompanyConstants.companyProfilePath,
    );
    if (snapshot.exists && snapshot.value is Map) {
      return snapshot.value as Map<dynamic, dynamic>;
    }
    return null;
  }

  static Future<void> saveCompanyProfile(Map<String, Object?> payload) async {
    await rtdbService.updateData(
      EditCompanyConstants.companyProfilePath,
      payload,
    );
  }

  static Future<void> logError(Object error, StackTrace stackTrace) async {
    await rtdbService.logAppError(
      source: 'EditCompanyController.saveChanges',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
