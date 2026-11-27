import 'package:flutter/material.dart';

import 'logic/company_profile_logic.dart';
import 'ui/appbar/company_profile_appbar.dart';
import 'ui/appbody/company_profile_body.dart';

/// Halaman Profil Perusahaan (`CompanyProfile`) khusus tampilan & navigasi edit.
class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  late final CompanyProfileLogic _logic;
  late final Future<bool> _adminFuture;

  @override
  void initState() {
    super.initState();
    _logic = CompanyProfileLogic();
    _adminFuture = _logic.isAdmin();
    _logic.logScreenOpen('company_profile');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _adminFuture,
      builder: (context, adminSnapshot) {
        final bool isAdmin = adminSnapshot.data ?? false;

        return Scaffold(
          appBar: CompanyProfileAppBar(
            isAdmin: isAdmin,
            onEditPressed: () => _logic.navigateToEdit(context),
          ),
          body: CompanyProfileBody(logic: _logic),
        );
      },
    );
  }
}
