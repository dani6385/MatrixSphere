//import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
//import 'package:shared_services/services/firebase_options.dart'; // Corrected import path
//import 'navigations/app_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

void main() async {
  // 1. Pastikan binding diinisialisasi terlebih dahulu
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 2. Pilih opsi Firebase yang benar untuk aplikasi ini
    FirebaseOptions options;
    if (kIsWeb) {
      options = DefaultFirebaseOptions.web;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          options = DefaultFirebaseOptions.shopSphereAndroid;
          break;
        case TargetPlatform.iOS:
          options = DefaultFirebaseOptions.shopSphereIos;
          break;
        default:
          throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.',
          );
      }
    }

    // 3. Inisialisasi Firebase dengan opsi yang dipilih
    await Firebase.initializeApp(
      options: options,
    );

    // 4. Set up Crashlytics hanya jika Firebase berhasil diinisialisasi
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint("Firebase & Crashlytics berhasil dikonfigurasi untuk Shop Sphere.");
  } catch (e, stack) {
    // Jika Firebase gagal, aplikasi TIDAK AKAN layar hitam, melainkan tetap berjalan
    // dan menampilkan pesan error ini di konsol debug Anda.
    debugPrint("Gagal menginisialisasi Firebase: $e");
    debugPrint(stack.toString());
  }

  // 5. Selalu panggil runApp di luar blok inisialisasi agar layar hitam terhindari
  runApp(const ShopSphere());
}

class ShopSphere extends StatefulWidget {
  const ShopSphere({super.key});

  @override
  State<ShopSphere> createState() => _ShopSphereState();
}

class _ShopSphereState extends State<ShopSphere> {
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = AuthBloc(authService: AuthService());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        //ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Shop Sphere',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            //routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
