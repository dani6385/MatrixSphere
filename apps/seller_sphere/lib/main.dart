import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'navigations/app_router.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    FirebaseOptions options;
    if (kIsWeb) {
      options = DefaultFirebaseOptions.web;
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          options = DefaultFirebaseOptions.sellerSphereAndroid;
          break;
        case TargetPlatform.iOS:
          options = DefaultFirebaseOptions.sellerSphereIos;
          break;
        default:
          throw UnsupportedError(
            'DefaultFirebaseOptions are not supported for this platform.',
          );
      }
    }

    await Firebase.initializeApp(options: options);

    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    debugPrint(
      "Firebase & Crashlytics berhasil dikonfigurasi untuk Seller Sphere.",
    );
  } catch (e, stack) {
    debugPrint("Gagal menginisialisasi Firebase: $e");
    debugPrint(stack.toString());
  }

  runApp(const SellerSphere());
}

class SellerSphere extends StatefulWidget {
  const SellerSphere({super.key});

  @override
  State<SellerSphere> createState() => _SellerSphereState();
}

class _SellerSphereState extends State<SellerSphere> {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialApp.router(
          title: 'Seller Sphere',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        );
      },
    );
  }
}
