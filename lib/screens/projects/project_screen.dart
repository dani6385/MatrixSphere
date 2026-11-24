// lib/screens/projects/project_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_services/shared_services.dart';

class ProjectItem {
  final String id;
  final String name;
  final String subtitle;
  final String tag;
  final IconData icon;

  const ProjectItem({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.tag,
    required this.icon,
  });
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  static const List<ProjectItem> _projects = [
    ProjectItem(
      id: 'matrix_sphere',
      name: 'Matrix Sphere',
      subtitle: 'Portal utama, profil member, kehadiran & operasional inti',
      tag: 'Core',
      icon: Icons.hub_outlined,
    ),
    ProjectItem(
      id: 'admin_mikrotik',
      name: 'Admin Mikrotik',
      subtitle: 'Manajemen jaringan, router & monitoring perangkat',
      tag: 'Network',
      icon: Icons.router_outlined,
    ),
    ProjectItem(
      id: 'client_connect',
      name: 'Client Connect',
      subtitle: 'Komunikasi klien, tiket & layanan koneksi pelanggan',
      tag: 'Client',
      icon: Icons.support_agent_outlined,
    ),
    ProjectItem(
      id: 'seller_sphere',
      name: 'Seller Sphere',
      subtitle: 'Manajemen produk, stok barang & riwayat perubahan stok',
      tag: 'Seller',
      icon: Icons.storefront_outlined,
    ),
    ProjectItem(
      id: 'shop_sphere',
      name: 'Shop Sphere',
      subtitle: 'Katalog belanja, pesanan & alur transaksi toko',
      tag: 'Shop',
      icon: Icons.shopping_bag_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    analyticsService.logScreenView(screenName: 'project_screen');
    crashlyticsService.log('ProjectScreen initialized');
  }

  void _onSelectProject(ProjectItem project) {
    crashlyticsService.log('Selected project: ${project.id}');
    crashlyticsService.setCustomKey('active_project', project.id);

    analyticsService.logEvent(
      name: 'project_selected',
      parameters: {
        'project_id': project.id,
        'project_name': project.name,
        'project_tag': project.tag,
      },
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Membuka ${project.name}...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _recordTestNonFatalError() async {
    try {
      throw StateError('Simulasi non-fatal error dari ProjectScreen');
    } catch (error, stackTrace) {
      await crashlyticsService.recordError(
        error,
        stackTrace,
        reason: 'ProjectScreen test non-fatal error',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log non-fatal error dikirim ke Crashlytics'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _sendTestAnalyticsEvent() async {
    await analyticsService.logEvent(
      name: 'project_screen_diag_test',
      parameters: {
        'source': 'project_screen',
        'project_count': _projects.length,
      },
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Event diagnostik dikirim ke Analytics'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects Screen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Kartu status & diagnostik Firebase Analytics & Crashlytics
          Card(
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
                    children: [
                      Icon(Icons.insights_outlined, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Firebase Analytics & Crashlytics',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Memantau perpindahan layar, pemilihan proyek, serta breadcrumb & error non-fatal.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _sendTestAnalyticsEvent,
                        icon: const Icon(Icons.analytics_outlined, size: 18),
                        label: const Text('Tes Analytics'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _recordTestNonFatalError,
                        icon: const Icon(Icons.bug_report_outlined, size: 18),
                        label: const Text('Tes Crashlytics'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Text(
            'Daftar Proyek (${_projects.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),

          ..._projects.map(
            (project) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primaryContainer,
                  foregroundColor: colorScheme.onPrimaryContainer,
                  child: Icon(project.icon),
                ),
                title: Text(
                  project.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(project.subtitle),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Chip(
                      label: Text(project.tag),
                      visualDensity: VisualDensity.compact,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => _onSelectProject(project),
              ),
            ),
          ),
        ],
      ),
    );
  }
}