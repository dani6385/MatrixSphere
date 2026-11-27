import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrix_sphere/features/company/utils/company_image_helper.dart';
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

  Future<String> uploadCompanyImage({
    required File file,
    required String prefix,
    int maxWidth = 1080,
    int maxHeight = 1080,
    int quality = 75,
  }) async {
    try {
      final Uint8List? bytes = await CompanyImageHelper.compressToBytes(
        file: file,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
      );
      final String fileName =
          '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final ImgbbUploadResult result = await imgbbService.uploadBytes(
        bytes!,
        fileName: fileName,
      );
      return result.displayUrl.isNotEmpty ? result.displayUrl : result.url;
    } catch (e, stack) {
      await crashlyticsService.recordError(
        e,
        stack,
        reason: 'CompanyService.uploadCompanyImage($prefix)',
      );
      rethrow;
    }
  }

  Future<String> uploadCompanyBanner({
    required File file,
    required String prefix,
    int maxWidth = 1080,
    int maxHeight = 1080,
    int quality = 75,
  }) async {
    try {
      final Uint8List? bytes = await CompanyImageHelper.compressToBytes(
        file: file,
        minWidth: maxWidth,
        minHeight: maxHeight,
        quality: quality,
      );
      final String fileName =
          '${prefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      final ImgbbUploadResult result = await imgbbService.uploadBytes(
        bytes!,
        fileName: fileName,
      );
      return result.displayUrl.isNotEmpty ? result.displayUrl : result.url;
    } catch (e, stack) {
      await crashlyticsService.recordError(
        e,
        stack,
        reason: 'CompanyService.uploadCompanyImage($prefix)',
      );
      rethrow;
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
