import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_services/shared_services.dart';

import '../core/company_constants.dart';

class CompanyRemoteDataSource {
  final FirebaseAuth _auth;

  CompanyRemoteDataSource({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Stream<DatabaseEvent> watchCompanyProfileRaw() {
    return rtdbService.ref(CompanyConstants.dbNodeCompanyProfile).onValue;
  }

  Future<void> updateCompanyProfile(Map<String, Object?> payload) async {
    try {
      await rtdbService.updateData(
        CompanyConstants.dbNodeCompanyProfile,
        payload,
      );
      await crashlyticsService.log('Updated ${CompanyConstants.dbNodeCompanyProfile}');
    } catch (e, stack) {
      await rtdbService.logAppError(
        source: 'CompanyRemoteDataSource.updateCompanyProfile',
        error: e,
        stackTrace: stack,
      );
      await crashlyticsService.recordError(
        e,
        stack,
        reason: 'updateCompanyProfile failed',
      );
      rethrow;
    }
  }
}