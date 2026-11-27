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
}