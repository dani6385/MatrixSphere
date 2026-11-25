// lib/screens/system/system_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class SystemScreen extends StatefulWidget {
  final RtdbService? dbService;

  const SystemScreen({
    super.key,
    this.dbService,
  });

  @override
  State<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends State<SystemScreen>
    with SingleTickerProviderStateMixin {
  late final RtdbService _rtdbService;
  late final TabController _tabController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  String? _selectedShopId;

  @override
  void initState() {
    super.initState();
    _rtdbService = widget.dbService ?? rtdbService;
    _tabController = TabController(length: 4, vsync: this);

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser?.displayName != null &&
        currentUser!.displayName!.trim().isNotEmpty) {
      _ownerNameController.text = currentUser.displayName!.trim();
    }

    analyticsService.logScreenView(screenName: 'seller_system_screen');
    crashlyticsService.log('SystemScreen initialized');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _shopNameController.dispose();
    _categoryController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? get _activeUid => FirebaseAuth.instance.currentUser?.uid;

  Map<String, dynamic> _castSnapshotMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.map(
        (key, value) => MapEntry(key.toString(), value),
      );
    }
    return <String, dynamic>{};
  }

  List<MapEntry<String, Map<String, dynamic>>> _extractEntries(Object? raw) {
    if (raw == null || raw is! Map) return const [];
    final List<MapEntry<String, Map<String, dynamic>>> entries = [];
    for (final entry in raw.entries) {
      if (entry.value is Map) {
        entries.add(
          MapEntry(entry.key.toString(), _castSnapshotMap(entry.value)),
        );
      }
    }
    return entries;
  }

  Future<void> _submitShopRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    final String? uid = _activeUid;
    if (uid == null || uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan login terlebih dahulu untuk mendaftarkan toko.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final String shopId = _rtdbService.newKey('seller_registrations') ??
          'shop_${DateTime.now().millisecondsSinceEpoch}';

      final Map<String, Object?> payload = {
        'shopId': shopId,
        'ownerUid': uid,
        'shopName': _shopNameController.text.trim(),
        'category': _categoryController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'description': _descriptionController.text.trim(),
        'approvalStatus': 'pending', // pending | approved | rejected
        'ratingScore': 0.0,
        'totalSales': 0,
        'completedOrders': 0,
        'violationCount': 0,
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      };

      await _rtdbService.multiPathUpdate({
        'seller_registrations/$shopId': payload,
        'seller_registrations_by_user/$uid/$shopId': payload,
      });

      await analyticsService.logEvent(
        name: 'seller_shop_registered',
        parameters: {
          'shop_id': shopId,
          'category': _categoryController.text.trim(),
        },
      );
      await crashlyticsService.log('Seller registered shop: $shopId');

      _shopNameController.clear();
      _categoryController.clear();
      _phoneController.clear();
      _addressController.clear();
      _descriptionController.clear();

      if (!mounted) return;
      setState(() => _selectedShopId = shopId);
      _tabController.animateTo(1);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran toko berhasil dikirim ke antrean approval.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      await crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'SystemScreen._submitShopRegistration',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendaftarkan toko: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _updateApprovalDecision(
    String shopId,
    String? ownerUid,
    String decision,
  ) async {
    try {
      final Map<String, Object?> updates = {
        'approvalStatus': decision,
        'reviewedAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      };

      final Map<String, Object?> multiPaths = {
        'seller_registrations/$shopId/approvalStatus': decision,
        'seller_registrations/$shopId/reviewedAt': ServerValue.timestamp,
        'seller_registrations/$shopId/updatedAt': ServerValue.timestamp,
      };

      if (ownerUid != null && ownerUid.isNotEmpty) {
        multiPaths['seller_registrations_by_user/$ownerUid/$shopId/approvalStatus'] =
            decision;
        multiPaths['seller_registrations_by_user/$ownerUid/$shopId/reviewedAt'] =
            ServerValue.timestamp;
        multiPaths['seller_registrations_by_user/$ownerUid/$shopId/updatedAt'] =
            ServerValue.timestamp;
      }

      if (decision == 'approved') {
        multiPaths['shops/$shopId'] = {
          'shopId': shopId,
          'ownerUid': ownerUid ?? _activeUid ?? '',
          'status': 'active',
          'approvedAt': ServerValue.timestamp,
        };
      }

      await _rtdbService.multiPathUpdate(multiPaths);
      await analyticsService.logApprovalAction(
        targetType: 'seller_shop',
        decision: decision,
        targetId: shopId,
      );
      await crashlyticsService.log(
        'Shop $shopId approval status updated to $decision',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status approval diperbarui menjadi "$decision".'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Hindari unused variable warning jika updates ingin dipakai terpisah
      assert(updates.isNotEmpty);
    } catch (error, stackTrace) {
      await crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'SystemScreen._updateApprovalDecision',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui status approval: $error'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _showAddViolationDialog(
    String shopId,
    String shopName,
    int currentViolationCount,
  ) async {
    final TextEditingController reasonController = TextEditingController();
    String selectedSeverity = 'Ringan';
    String selectedPenalty = 'Peringatan Tertulis';

    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Catat Pelanggaran - $shopName'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: selectedSeverity,
                      decoration: const InputDecoration(
                        labelText: 'Tingkat Pelanggaran',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Ringan', child: Text('Ringan')),
                        DropdownMenuItem(value: 'Sedang', child: Text('Sedang')),
                        DropdownMenuItem(value: 'Berat', child: Text('Berat')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedSeverity = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedPenalty,
                      decoration: const InputDecoration(
                        labelText: 'Tindakan / Sanksi',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Peringatan Tertulis',
                          child: Text('Peringatan Tertulis'),
                        ),
                        DropdownMenuItem(
                          value: 'Pembatasan Produk',
                          child: Text('Pembatasan Produk'),
                        ),
                        DropdownMenuItem(
                          value: 'Penangguhan Sementara',
                          child: Text('Penangguhan Sementara'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedPenalty = val);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: reasonController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Uraian Pelanggaran',
                        hintText:
                            'Contoh: Keterlambatan pengiriman atau ketidaksesuaian deskripsi produk',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    if (reasonController.text.trim().isEmpty) return;
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) {
      reasonController.dispose();
      return;
    }

    final String reason = reasonController.text.trim();
    reasonController.dispose();

    try {
      final String violationId = _rtdbService.newKey('seller_violations/$shopId') ??
          'viol_${DateTime.now().millisecondsSinceEpoch}';
      final int nextCount = currentViolationCount + 1;

      await _rtdbService.multiPathUpdate({
        'seller_violations/$shopId/$violationId': {
          'violationId': violationId,
          'shopId': shopId,
          'shopName': shopName,
          'severity': selectedSeverity,
          'penalty': selectedPenalty,
          'reason': reason,
          'status': 'open',
          'reportedBy': _activeUid ?? 'system',
          'createdAt': ServerValue.timestamp,
        },
        'seller_registrations/$shopId/violationCount': nextCount,
      });

      await analyticsService.logEvent(
        name: 'seller_violation_recorded',
        parameters: {
          'shop_id': shopId,
          'severity': selectedSeverity,
          'penalty': selectedPenalty,
        },
      );
      await crashlyticsService.log(
        'Violation recorded for $shopId ($selectedSeverity)',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan pelanggaran seller berhasil disimpan.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error, stackTrace) {
      await crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'SystemScreen._showAddViolationDialog',
      );
    }
  }

  Widget _buildRegistrationTab(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: const Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  'Daftarkan toko Anda ke ekosistem Matrix Sphere. Setelah dikirim, '
                  'pengajuan akan masuk ke proses approval sebelum toko aktif beroperasi.',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shopNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Toko',
                prefixIcon: Icon(Icons.storefront_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama toko wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Kategori Utama Toko',
                hintText: 'Contoh: Elektronik, Kuliner, Perlengkapan Rumah',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Kategori wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: 'Nama Pemilik / PIC',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nama pemilik wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon / WhatsApp',
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nomor kontak wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Alamat Toko / Gudang',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Alamat wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Deskripsi Singkat Toko',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitShopRegistration,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send_outlined),
                label: Text(
                  _isSubmitting ? 'Mengirim Pendaftaran...' : 'Ajukan Pendaftaran Toko',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalTab(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: _rtdbService.ref('seller_registrations').onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Gagal memuat data approval: ${snapshot.error}'),
          );
        }

        final entries = _extractEntries(snapshot.data?.snapshot.value);
        if (entries.isEmpty) {
          return const Center(
            child: Text('Belum ada pendaftaran toko yang tercatat.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final String shopId = entries[index].key;
            final Map<String, dynamic> data = entries[index].value;
            final String shopName = data['shopName']?.toString() ?? 'Toko Tanpa Nama';
            final String category = data['category']?.toString() ?? '-';
            final String ownerName = data['ownerName']?.toString() ?? '-';
            final String ownerUid = data['ownerUid']?.toString() ?? '';
            final String status = data['approvalStatus']?.toString() ?? 'pending';
            final bool isHighlighted = _selectedShopId == shopId;

            Color badgeColor;
            String statusLabel;
            switch (status) {
              case 'approved':
                badgeColor = Colors.green;
                statusLabel = 'Disetujui';
                break;
              case 'rejected':
                badgeColor = Colors.red;
                statusLabel = 'Ditolak';
                break;
              default:
                badgeColor = Colors.orange;
                statusLabel = 'Menunggu Approval';
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isHighlighted
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: isHighlighted ? 1.5 : 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            shopName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Chip(
                          label: Text(
                            statusLabel,
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          side: BorderSide(color: badgeColor),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Kategori: $category • PIC: $ownerName'),
                    Text(
                      'ID Toko: $shopId',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonalIcon(
                          onPressed: status == 'approved'
                              ? null
                              : () => _updateApprovalDecision(
                                    shopId,
                                    ownerUid,
                                    'approved',
                                  ),
                          icon: const Icon(Icons.check_circle_outline, size: 18),
                          label: const Text('Setujui'),
                        ),
                        OutlinedButton.icon(
                          onPressed: status == 'rejected'
                              ? null
                              : () => _updateApprovalDecision(
                                    shopId,
                                    ownerUid,
                                    'rejected',
                                  ),
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Tolak'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildViolationsTab(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: _rtdbService.ref('seller_registrations').onValue,
      builder: (context, regSnapshot) {
        final shops = _extractEntries(regSnapshot.data?.snapshot.value);

        return StreamBuilder<DatabaseEvent>(
          stream: _rtdbService.ref('seller_violations').onValue,
          builder: (context, violSnapshot) {
            if (violSnapshot.connectionState == ConnectionState.waiting &&
                !violSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            /*final List> violationItems = [];
            final rawViolations = violSnapshot.data?.snapshot.value;
            if (rawViolations is Map) {
              for (final shopEntry in rawViolations.entries) {
                if (shopEntry.value is Map) {
                  for (final itemEntry in (shopEntry.value as Map).entries) {
                    if (itemEntry.value is Map) {
                      violationItems.add(_castSnapshotMap(itemEntry.value));
                    }
                  }
                }
              }
            }*/

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (shops.isNotEmpty) ...[
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Catat Pelanggaran Seller',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...shops.map((entry) {
                    final String shopId = entry.key;
                    final Map<String, dynamic> data = entry.value;
                    final String shopName =
                        data['shopName']?.toString() ?? 'Toko Tanpa Nama';
                    final int violationCount =
                        (data['violationCount'] as num?)?.toInt() ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.gavel_outlined),
                        title: Text(shopName),
                        subtitle: Text('Total pelanggaran: $violationCount'),
                        trailing: OutlinedButton(
                          onPressed: () => _showAddViolationDialog(
                            shopId,
                            shopName,
                            violationCount,
                          ),
                          child: const Text('+ Pelanggaran'),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],/*
                Text(
                  'Riwayat Pelanggaran (${violationItems.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),*/
                const SizedBox(height: 8),
                /*if (violationItems.isEmpty)
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Tidak ada catatan pelanggaran seller.'),
                    ),
                  )*/
                /*else
                  ...violationItems.map((item) {
                    final String shopName =
                        item['shopName']?.toString() ?? 'Toko';
                    final String severity =
                        item['severity']?.toString() ?? 'Ringan';
                    final String penalty =
                        item['penalty']?.toString() ?? '-';
                    final String reason = item['reason']?.toString() ?? '-';

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.warning_amber_rounded,
                          color: colorScheme.error,
                        ),
                        title: Text('$shopName • $severity'),
                        subtitle: Text('Sanksi: $penalty\nAlasan: $reason'),
                        isThreeLine: true,
                      ),
                    );
                  }),*/
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildGrowthTab(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<DatabaseEvent>(
      stream: _rtdbService.ref('seller_registrations').onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final entries = _extractEntries(snapshot.data?.snapshot.value);
        if (entries.isEmpty) {
          return const Center(
            child: Text('Belum ada data perkembangan seller.'),
          );
        }

        int totalShops = entries.length;
        int approvedShops = 0;
        int totalOrders = 0;
        int totalViolations = 0;

        for (final entry in entries) {
          final Map<String, dynamic> data = entry.value;
          if (data['approvalStatus']?.toString() == 'approved') {
            approvedShops++;
          }
          totalOrders += (data['completedOrders'] as num?)?.toInt() ?? 0;
          totalViolations += (data['violationCount'] as num?)?.toInt() ?? 0;
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.55,
              children: [
                _buildSummaryTile(
                  context,
                  label: 'Total Toko Terdaftar',
                  value: '$totalShops',
                  icon: Icons.store_outlined,
                ),
                _buildSummaryTile(
                  context,
                  label: 'Toko Aktif / Approved',
                  value: '$approvedShops',
                  icon: Icons.verified_outlined,
                ),
                _buildSummaryTile(
                  context,
                  label: 'Pesanan Selesai',
                  value: '$totalOrders',
                  icon: Icons.shopping_bag_outlined,
                ),
                _buildSummaryTile(
                  context,
                  label: 'Total Pelanggaran',
                  value: '$totalViolations',
                  icon: Icons.report_problem_outlined,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'Perkembangan Tiap Seller',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...entries.map((entry) {
              final Map<String, dynamic> data = entry.value;
              final String shopName =
                  data['shopName']?.toString() ?? 'Toko Tanpa Nama';
              final String status =
                  data['approvalStatus']?.toString() ?? 'pending';
              final int completedOrders =
                  (data['completedOrders'] as num?)?.toInt() ?? 0;
              final double rating =
                  (data['ratingScore'] as num?)?.toDouble() ?? 0.0;
              final int violations =
                  (data['violationCount'] as num?)?.toInt() ?? 0;

              final double healthScore = ((status == 'approved' ? 0.4 : 0.15) +
                      (completedOrders.clamp(0, 50) / 50) * 0.4 -
                      (violations * 0.1))
                  .clamp(0.0, 1.0);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            shopName,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Rating: ${rating.toStringAsFixed(1)} ★'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Status: $status • Pesanan selesai: $completedOrders • Pelanggaran: $violations',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: healthScore),
                      const SizedBox(height: 4),
                      Text(
                        'Indeks Kesehatan Seller: ${(healthScore * 100).round()}%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildSummaryTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Seller Matrix Sphere'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.app_registration), text: 'Pendaftaran'),
            Tab(icon: Icon(Icons.verified_user_outlined), text: 'Approval'),
            Tab(icon: Icon(Icons.gavel_outlined), text: 'Pelanggaran'),
            Tab(icon: Icon(Icons.trending_up), text: 'Perkembangan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRegistrationTab(context),
          _buildApprovalTab(context),
          _buildViolationsTab(context),
          _buildGrowthTab(context),
        ],
      ),
    );
  }
}
