import 'package:flutter/material.dart';

import 'widgets/app_bar.dart';
import 'widgets/app_body.dart';
import 'logics/edit_company_controller.dart';
import 'models/company_profile_model.dart';

class EditCompanyPage extends StatefulWidget {
  final CompanyProfileModel? initialCompany;

  const EditCompanyPage({super.key, this.initialCompany});

  @override
  State<EditCompanyPage> createState() => _EditCompanyPageState();
}

class _EditCompanyPageState extends State<EditCompanyPage> {
  late final EditCompanyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditCompanyController(initialCompany: widget.initialCompany)
      ..addListener(_onControllerUpdated);
  }

  void _onControllerUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleSave() async {
    final bool saved = await _controller.saveChanges(
      onShowMessage: (message) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
    if (saved && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdated);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isCheckingAdmin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: EditCompanyAppBar(
        isAdmin: _controller.isAdmin,
        isSaving: _controller.isSaving,
        onSave: _handleSave,
      ),
      body: EditCompanyAppBody(
        controller: _controller,
        onSave: _handleSave,
      ),
    );
  }
}