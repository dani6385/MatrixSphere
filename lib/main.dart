
import 'package:flutter/material.dart';
import 'screens/homes/home_screen.dart';

void main() {
  runApp(const MatrixSphere());
}

class MatrixSphere extends StatelessWidget {
  const MatrixSphere({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Matrix Sphere',
      home: HomeScreen(),
    );
  }
}
