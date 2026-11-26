import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';

import '../core/company_profile_constants.dart';
import '../models/company_profile_view_data.dart';

class CompanyProfileService {
  CompanyProfileService._();

  static Stream<DatabaseEvent> watchCompanyProfile() {
    return rtdbService.ref(CompanyProfileConstants.companyProfilePath).onValue;
  }

  static Future<Map<dynamic, dynamic>?> loadCompanyProfileMap() async {
    final DataSnapshot snapshot = await rtdbService.getSnapshot(
      CompanyProfileConstants.companyProfilePath,
    );
    if (snapshot.exists && snapshot.value is Map) {
      return snapshot.value as Map<dynamic, dynamic>;
    }
    return null;
  }

  static Future<AccessRoleResult> resolveAccessRole(User? user) async {
    if (user == null) {
      return const AccessRoleResult(isAdmin: false, isHrManager: false);
    }

    bool isAdmin = user.uid == CompanyProfileConstants.permanentAdminUid;
    bool isHrManager = false;

    try {
      final IdTokenResult tokenResult = await user.getIdTokenResult(true);
      final Map<String, dynamic>? claims = tokenResult.claims;
      if (claims != null) {
        if (claims['admin'] == true || claims['isAdmin'] == true) {
          isAdmin = true;
        }
        final String claimRole =
            claims['role']?.toString().trim().toLowerCase() ?? '';
        if (claims['hrManager'] == true ||
            claims['isHrManager'] == true ||
            claims['managerKepegawaian'] == true ||
            claimRole == 'hr_manager' ||
            claimRole == 'manager_kepegawaian' ||
            claimRole == 'manager kepegawaian') {
          isHrManager = true;
        }
      }
    } catch (_) {
      // Lanjutkan pengecekan ke RTDB jika token claim gagal diambil
    }

    if (!isAdmin && !isHrManager) {
      try {
        final DataSnapshot memberSnap = await rtdbService.getSnapshot(
          'members/matrix_member/${user.uid}',
        );
        if (memberSnap.exists && memberSnap.value is Map) {
          final Map<dynamic, dynamic> memberData =
              memberSnap.value as Map<dynamic, dynamic>;
          final String role =
              memberData['role']?.toString().trim().toLowerCase() ?? '';
          final String position =
              memberData['position']?.toString().trim().toLowerCase() ?? '';
          final String department =
              memberData['department']?.toString().trim().toLowerCase() ?? '';

          if (role == 'admin' || memberData['isAdmin'] == true) {
            isAdmin = true;
          }
          if (role == 'hr_manager' ||
              role == 'manager_kepegawaian' ||
              role.contains('manager kepegawaian') ||
              position.contains('manager kepegawaian') ||
              position.contains('manajer kepegawaian') ||
              (department.contains('kepegawaian') &&
                  (position.contains('manager') ||
                      position.contains('manajer')))) {
            isHrManager = true;
          }
        }
      } catch (_) {
        // Abaikan jika node member tidak terbaca
      }
    }

    return AccessRoleResult(isAdmin: isAdmin, isHrManager: isHrManager);
  }

  static Future<bool> checkIsAdmin() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    if (user.uid == CompanyProfileConstants.permanentAdminUid) return true;

    final IdTokenResult tokenResult = await user.getIdTokenResult(true);
    final Map<String, dynamic>? claims = tokenResult.claims;
    return claims?['admin'] == true || claims?['isAdmin'] == true;
  }

  static Future<void> saveCompanyProfile(Map<String, Object?> payload) async {
    await rtdbService.updateData(
      CompanyProfileConstants.companyProfilePath,
      payload,
    );
  }

  static Future<void> updateOvertimeWork(Map<String, Object?> payload) async {
    await rtdbService.updateData(
      CompanyProfileConstants.companyProfilePath,
      payload,
    );
  }

  static Future<void> logError(
    Object error,
    StackTrace stackTrace, {
    String source = 'CompanyProfileService',
  }) async {
    await rtdbService.logAppError(
      source: source,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

typedef CompanyService = CompanyProfileService;
