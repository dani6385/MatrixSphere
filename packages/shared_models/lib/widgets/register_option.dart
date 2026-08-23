import 'package:flutter/material.dart';
import 'package:shared_navigations/shared_navigations.dart';

class RegisterOption extends StatelessWidget {
  const RegisterOption({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Belum memiliki akun? '),
        GestureDetector(
          onTap: () {
            NavigationService.navigateTo(AppRoutes.register);
          },
          child: const Text(
            'Daftar Sekarang',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ],
    );
  }
}