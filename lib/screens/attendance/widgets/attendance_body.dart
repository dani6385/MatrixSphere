import 'package:flutter/material.dart';
import 'package:shared_ui/shared_ui.dart';

class AttendanceBody extends StatelessWidget {
  /// Menandakan apakah kamera sudah siap digunakan.
  final bool isCameraInitialized;

  /// Menandakan apakah aplikasi sedang mengambil titik koordinat GPS.
  final bool isLoadingLocation;

  /// Menandakan apakah posisi pengguna berada di dalam radius absensi.
  final bool isInRange;

  /// Jarak pengguna saat ini ke titik lokasi kerja (dalam meter).
  final double distanceToOffice;

  /// Menandakan apakah data absensi sedang diproses/dikirim.
  final bool isProcessing;

  /// Callback saat tombol absen ditekan.
  final VoidCallback? onSubmit;

  /// Widget pratinjau kamera opsional (contoh: `CameraPreview(controller)`).
  final Widget? cameraPreview;

  /// Jarak bawah agar panel tidak tertutup BottomNavBar.
  final double bottomSafeSpacing;

  /// Nama lokasi kantor / proyek / titik kerja.
  final String officeName;

  /// `false` = mode Check-In (mulai kerja), `true` = mode Check-Out (selesai kerja).
  final bool isCheckOutMode;

  /// Callback saat pengguna mengubah mode Check-In / Check-Out.
  final ValueChanged<bool>? onModeChanged;

  /// Callback saat tombol refresh lokasi GPS ditekan.
  final VoidCallback? onRefreshLocation;

  /// Teks jam Check-In hari ini jika sudah ada (contoh: "07:55").
  final String? checkInTimeText;

  /// Teks jam Check-Out hari ini jika sudah ada (contoh: "16:30").
  final String? checkOutTimeText;

  const AttendanceBody({
    super.key,
    required this.isCameraInitialized,
    required this.isLoadingLocation,
    required this.isInRange,
    required this.distanceToOffice,
    required this.isProcessing,
    required this.onSubmit,
    this.cameraPreview,
    this.bottomSafeSpacing = 92.0,
    this.officeName = 'Lokasi Kerja Utama',
    this.isCheckOutMode = false,
    this.onModeChanged,
    this.onRefreshLocation,
    this.checkInTimeText,
    this.checkOutTimeText,
  });

  /// Tombol absen hanya aktif jika kamera siap, GPS tidak sedang memuat,
  /// berada di dalam radius, dan tidak sedang memproses data.
  bool get _canSubmit =>
      isCameraInitialized &&
      !isLoadingLocation &&
      isInRange &&
      !isProcessing &&
      onSubmit != null;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // 1. Lapisan dasar: kamera / pratinjau
        Positioned.fill(
          child: _buildCameraSection(),
        ),

        // 2. Lapisan atas: informasi lokasi, jam real-time, dan status GPS
        Positioned(
          top: 12,
          left: 16,
          right: 16,
          child: SafeArea(
            bottom: false,
            child: _buildInfoAndLocationCard(colorScheme),
          ),
        ),

        // 3. Lapisan bawah: mode Check-In / Check-Out, jam tercatat, dan tombol aksi
        Positioned(
          left: 16,
          right: 16,
          bottom: bottomSafeSpacing,
          child: _buildActionPanel(colorScheme),
        ),
      ],
    );
  }

  /// Menampilkan pratinjau kamera atau indikator saat kamera disiapkan.
  Widget _buildCameraSection() {
    if (!isCameraInitialized) {
      return Container(
        color: Colors.black87,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Menyiapkan kamera...',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    if (cameraPreview != null) {
      return cameraPreview!;
    }

    return Container(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamera Siap Digunakan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu informasi lokasi kerja, jam berjalan real-time, dan status GPS.
  Widget _buildInfoAndLocationCard(ColorScheme colorScheme) {
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    if (isLoadingLocation) {
      statusColor = Colors.orange;
      statusIcon = Icons.my_location;
      statusText = 'Mencari titik GPS...';
    } else if (isInRange) {
      statusColor = Colors.green;
      statusIcon = Icons.check_circle;
      statusText = 'Dalam Radius (${distanceToOffice.toStringAsFixed(1)} m)';
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.location_off;
      statusText = 'Di Luar Radius (${distanceToOffice.toStringAsFixed(1)} m)';
    }

    return Card(
      elevation: 4,
      color: colorScheme.surface.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: statusColor.withValues(alpha: 0.45), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris 1: Nama lokasi kerja + Jam berjalan real-time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.business, size: 18, color: kBrandPrimary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          officeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const _LiveClockBadge(),
              ],
            ),
            const Divider(height: 16),
            // Baris 2: Status radius GPS + Tombol refresh lokasi
            Row(
              children: [
                isLoadingLocation
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: statusColor,
                        ),
                      )
                    : Icon(statusIcon, color: statusColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: isLoadingLocation ? null : onRefreshLocation,
                  tooltip: 'Refresh Lokasi',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.refresh,
                    color: onRefreshLocation == null
                        ? colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                        : kBrandPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Panel bawah: pemilih Check-In / Check-Out, riwayat jam hari ini, dan tombol submit.
  Widget _buildActionPanel(ColorScheme colorScheme) {
    final String activeActionLabel =
        isCheckOutMode ? 'Check-Out (Selesai Kerja)' : 'Check-In (Mulai Kerja)';
    final String buttonLabel = isProcessing
        ? 'Menyimpan Absensi...'
        : (isCheckOutMode ? 'Absen Check-Out' : 'Absen Check-In');

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pemilih mode Check-In dan Check-Out
          Row(
            children: [
              Expanded(
                child: _ModeChoiceChip(
                  label: 'Check-In',
                  icon: Icons.login,
                  selected: !isCheckOutMode,
                  onTap: isProcessing || onModeChanged == null
                      ? null
                      : () => onModeChanged!(false),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ModeChoiceChip(
                  label: 'Check-Out',
                  icon: Icons.logout,
                  selected: isCheckOutMode,
                  onTap: isProcessing || onModeChanged == null
                      ? null
                      : () => onModeChanged!(true),
                ),
              ),
            ],
          ),

          // Informasi jam Check-In / Check-Out jika tersedia
          if (checkInTimeText != null || checkOutTimeText != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Masuk: ${checkInTimeText ?? '--:--'}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Pulang: ${checkOutTimeText ?? '--:--'}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 10),
          Text(
            'Mode aktif: $activeActionLabel',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),

          // Tombol utama Check-In / Check-Out
          ElevatedButton.icon(
            onPressed: _canSubmit ? onSubmit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isCheckOutMode ? Colors.deepOrange : kBrandPrimary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: colorScheme.surfaceContainerHighest,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Icon(isCheckOutMode ? Icons.logout : Icons.login),
            label: Text(
              buttonLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol pilihan mode Check-In / Check-Out.
class _ModeChoiceChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  const _ModeChoiceChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 10),
        decoration: BoxDecoration(
          color: selected
              ? kBrandPrimary.withValues(alpha: 0.16)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? kBrandPrimary : colorScheme.outlineVariant,
            width: selected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? kBrandPrimary : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                color: selected ? kBrandPrimary : colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge jam berjalan real-time (HH:mm:ss) yang memperbarui diri tiap detik.
class _LiveClockBadge extends StatelessWidget {
  const _LiveClockBadge();

  String _formatNow(DateTime now) {
    final String hh = now.hour.toString().padLeft(2, '0');
    final String mm = now.minute.toString().padLeft(2, '0');
    final String ss = now.second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream<DateTime>.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      initialData: DateTime.now(),
      builder: (context, snapshot) {
        final DateTime currentTime = snapshot.data ?? DateTime.now();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: kBrandPrimary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _formatNow(currentTime),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: kBrandPrimary,
            ),
          ),
        );
      },
    );
  }
}