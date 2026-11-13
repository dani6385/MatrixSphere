import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required int selectedIndex,
    required List<GButton> tabs,
    required List<dynamic> items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Latar Belakang Navbar Berwarna Biru Cerah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 65,
              decoration: const BoxDecoration(
                color:
                    Color(0xFF00E5FF), // Warna Cyan / Biru Terang sesuai gambar
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Spacer untuk memberi ruang pada tombol aktif yang melayang di kiri
                  const SizedBox(width: 70),
                  // Ikon menu ke-2 (Centang)
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.black87),
                    onPressed: () => onTap(1),
                  ),
                  // Ikon menu ke-3 (Grafik/Analytics)
                  IconButton(
                    icon: const Icon(Icons.bar_chart, color: Colors.black87),
                    onPressed: () => onTap(2),
                  ),
                  // Ikon menu ke-4 (Dokumen)
                  IconButton(
                    icon: const Icon(Icons.description_outlined,
                        color: Colors.black87),
                    onPressed: () => onTap(3),
                  ),
                  // Ikon menu ke-5 (Profil)
                  IconButton(
                    icon:
                        const Icon(Icons.person_outline, color: Colors.black87),
                    onPressed: () => onTap(4),
                  ),
                ],
              ),
            ),
          ),

          // Tombol Aktif Melayang di Sebelah Kiri (Home)
          Positioned(
            left: 24,
            bottom: 20, // Membuat tombol sedikit keluar ke atas navbar
            child: GestureDetector(
              onTap: () => onTap(0),
              child: Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E2C), // Warna latar gelap melingkar
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
