import 'package:flutter/material.dart';

import 'widgets/app_bar.dart';
import 'widgets/app_body.dart';
import 'logics/company_profile_controller.dart';
import 'models/company_profile_model.dart';

class CompanyPage extends StatefulWidget {
  final CompanyProfileModel? initialCompany;

  const CompanyPage({super.key, this.initialCompany});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  late final CompanyController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CompanyController(initialCompany: widget.initialCompany)
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
      appBar: CompanyAppBar(
        isAdmin: _controller.isAdmin,
        isSaving: _controller.isSaving,
        onSave: _handleSave,
      ),
      body: CompanyAppBody(
        controller: _controller,
        onSave: _handleSave,
      ),
    );
  }
}