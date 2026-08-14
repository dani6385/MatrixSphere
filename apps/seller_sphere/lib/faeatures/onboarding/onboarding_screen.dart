import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_navigations/shared_navigation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              _buildPage(
                "Selamat Datang",
                "Kelola tokomu dengan mudah di Seller Sphere.", null
              ),
              _buildPage(
                "Pantau Penjualan",
                "Lihat laporan real-time kapan saja.", null
              ),
              _buildPage(
                "Mulai Sekarang",
                "Daftarkan tokomu dan raih keuntungan.",
                ElevatedButton(
                  onPressed: () => context.go(AppRoutes.login), // Navigasi ke login
                  child: const Text("Mulai"),
                ),
              ),
            ],
          ),

          // Indikator Titik
          Container(
            alignment: const Alignment(0, 0.8),
            child: SmoothPageIndicator(controller: _controller, count: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(String title, String description, Widget? actionButton) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text(description, textAlign: TextAlign.center),
          if (actionButton != null) ...[
            const SizedBox(height: 30),
            actionButton,
          ],
        ],
      ),
    );
  }
}