import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_services/shared_services.dart';

import '../core/company_constants.dart';
import '../data/company_remote_datasource.dart';
import '../models/attendance_rule_model.dart';
import '../models/company_profile_model.dart';

class CompanyProfileBundle {
  final CompanyProfileModel company;
  final AttendanceRuleModel attendanceRule;

  const CompanyProfileBundle({
    required this.company,
    required this.attendanceRule,
  });
}

class CompanyService {
  final CompanyRemoteDataSource _dataSource;

  CompanyService({CompanyRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? CompanyRemoteDataSource();

  Future<bool> checkIsMatrixAdmin() async {
    final User? user = _dataSource.currentUser;
    if (user == null) return false;
    if (user.uid == CompanyConstants.permanentAdminUid) return true;

    try {
      final IdTokenResult tokenResult = await user.getIdTokenResult(true);
      final Map<String, dynamic>? claims = tokenResult.claims;
      return claims?['admin'] == true || claims?['isAdmin'] == true;
    } catch (e, stack) {
      await crashlyticsService.recordError(
        e,
        stack,
        reason: 'checkIsMatrixAdmin failed',
      );
      return false;
    }
  }

  Stream<CompanyProfileBundle> watchCompanyBundle() {
    return _dataSource.watchCompanyProfileRaw().map((event) {
      Map<dynamic, dynamic>? rawData;
      if (event.snapshot.value is Map) {
        rawData = event.snapshot.value as Map<dynamic, dynamic>;
      }

      return CompanyProfileBundle(
        company: CompanyProfileModel.fromMap(rawData),
        attendanceRule: AttendanceRuleModel.fromMap(rawData),
      );
    });
  }

  Future<void> saveCompanyProfile(Map<String, Object?> payload) async {
    await _dataSource.updateCompanyProfile(payload);
    await analyticsService.logSystemAction(
      targetType: 'company_profile',
      decision: 'updated',
      targetId: CompanyConstants.dbNodeCompanyProfile,
    );
  }
}