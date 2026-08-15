import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:seller_sphere/features/shop/bloc/shop_bloc.dart';
import 'package:seller_sphere/features/shop/repositories/shop_repository.dart';
import 'package:shared_services/shared_services.dart';
import 'package:seller_sphere/features/shop/presentations/widgets/shop_form_field.dart';

class ShopRegistrationScreen extends StatelessWidget {
  const ShopRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ShopRepository(),
      child: BlocProvider(
        create: (context) => ShopBloc(
          shopRepository: context.read<ShopRepository>(),
        ),
        child: const ShopRegistrationView(),
      ),
    );
  }
}

class ShopRegistrationView extends StatefulWidget {
  const ShopRegistrationView({super.key});

  @override
  State<ShopRegistrationView> createState() => _ShopRegistrationViewState();
}

class _ShopRegistrationViewState extends State<ShopRegistrationView> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _shopDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // PERBAIKAN 1: Menggunakan instance global analyticsService
    analyticsService.logEvent(
      'begin_shop_registration',
      parameters: {
        'event_category': 'engagement',
        'event_label': 'start',
      },
    );
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _shopDescriptionController.dispose();
    super.dispose();
  }

  void _onCreateShopPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ShopBloc>().add(
            CreateShopRequested(
              name: _shopNameController.text.trim(),
              description: _shopDescriptionController.text.trim(),
            ),
          );
    }
  }

  void _listenToShopState(BuildContext context, ShopState state) {
    if (state is ShopCreationSuccess) {
      // PERBAIKAN 2: Mengganti FirebaseAnalyticsService yang error dengan analyticsService
      analyticsService.logEvent(
        'complete_shop_registration',
        parameters: {
          'event_category': 'engagement',
          'event_label': 'success',
        },
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Toko Anda berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );

      context.go('/');
    } else if (state is ShopCreationFailure) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('Gagal membuat toko: ${state.error}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Toko Anda'),
      ),
      body: BlocListener<ShopBloc, ShopState>(
        listener: _listenToShopState,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Satu Langkah Lagi',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lengkapi detail untuk membuka toko Anda.',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  ShopFormField(
                    controller: _shopNameController,
                    labelText: 'Nama Toko',
                    hintText: 'Contoh: Kopi Kenangan Jiwa',
                    prefixIcon: Icons.storefront_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama toko tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  ShopFormField(
                    controller: _shopDescriptionController,
                    labelText: 'Deskripsi Singkat Toko',
                    hintText: 'Contoh: Menjual aneka kopi dan makanan ringan',
                    prefixIcon: Icons.description_outlined,
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  BlocBuilder<ShopBloc, ShopState>(
                    builder: (context, state) {
                      if (state is ShopLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _onCreateShopPressed,
                        child: const Text('BUAT TOKO SEKARANG'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}