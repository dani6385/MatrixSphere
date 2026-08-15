import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:seller_sphere/navigations/app_router.dart';
//import 'package:seller_sphere/providers/app_provider.dart';
import 'package:shared_services/shared_services.dart';
import 'package:shared_ui/shared_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Setup centralized fatal error handling
    FlutterError.onError = crashlyticsService.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      crashlyticsService.recordFatalError(error, stack);
      return true; // Mark as handled
    };

    debugPrint("Firebase & Crashlytics berhasil dikonfigurasi.");
  } catch (e, stack) {
    crashlyticsService.recordError(
      e,
      stack,
      reason: 'Failed to initialize Firebase',
    );
  }

  runApp(const SellerSphere());
}

class SellerSphere extends StatefulWidget {
  const SellerSphere({super.key});

  @override
  State<SellerSphere> createState() => _SellerSphereState();
}

class _SellerSphereState extends State<SellerSphere> {
  late final AuthBloc _authBloc;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _authBloc = AuthBloc(authService: _authService);
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
          //final appProvider = context.watch<AppProvider>();
          return MaterialApp.router(
            title: 'Seller Sphere',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            //themeMode: appProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
