import 'package:flutter/material.dart';

/// Widget wadah (container) di bagian bawah layar untuk menampung tombol aksi [ActionButton].
/// 
/// Mengatur tata letak tombol secara responsif serta dilengkapi dengan [SafeArea] 
/// dan bayangan tipis di bagian atas wadah.
class ActionBottom extends StatelessWidget {
  /// Daftar tombol yang akan ditampilkan (misalnya [ActionButton])
  final List<Widget> children;

  /// Warna latar belakang wadah (opsional, bawaan menggunakan warna surface tema)
  final Color? backgroundColor;

  /// Jarak dalam (padding) di sekitar tombol
  final EdgeInsetsGeometry? padding;

  const ActionBottom({
    super.key,
    required this.children,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -3), // Efek bayangan ke arah atas
          ),
        ],
      ),
      child: SafeArea(
        top: false, // Hanya mengamankan bagian bawah layar
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildSpacedChildren(),
        ),
      ),
    );
  }

  /// Fungsi pembantu untuk memberi jarak otomatis antar tombol jika tombol lebih dari 1
  List<Widget> _buildSpacedChildren() {
    if (children.isEmpty) return [];

    // Jika hanya ada 1 tombol, buat tombol memenuhi lebar layar
    if (children.length == 1) {
      return [Expanded(child: children.first)];
    }

    // Jika ada lebih dari 1 tombol, berikan jarak 12px di antara tombol
    final List<Widget> spacedList = [];
    for (int i = 0; i < children.length; i++) {
      spacedList.add(Expanded(child: children[i]));
      if (i < children.length - 1) {
        spacedList.add(const SizedBox(width: 12));
      }
    }
    return spacedList;
  }
}