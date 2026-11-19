import 'package:flutter/material.dart';
import 'navigations/app_router.dart';

void main() {
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Matrix Sphere',
      routerConfig: appRouter,
    );
  }
}