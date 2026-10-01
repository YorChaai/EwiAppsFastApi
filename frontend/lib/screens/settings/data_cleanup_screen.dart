import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/core/notification_provider.dart';
import 'package:expense_app/theme/app_theme.dart';

class DataCleanupScreen extends StatefulWidget {
  const DataCleanupScreen({super.key});

  @override
  State<DataCleanupScreen> createState() => DataCleanupScreenState();
}

class DataCleanupScreenState extends State<DataCleanupScreen> {
  final PageController pageController = PageController();
  int currentStep = 0;
  bool loading = false;

  // Selection state
  final List<int> selectedYears = [];
  final List<String> selectedModules = [];
  List<dynamic> previewData = [];

  // Verification state
  final TextEditingController confirmController = TextEditingController();
  bool isConfirmTyped = false;

  final List<int> years = List.generate(21, (i) => 2020 + i); // 2020 to 2040
  final List<Map<String, dynamic>> modules = [
    {
      'id': 'settlement',
      'label': 'Settlement',
      'icon': Icons.receipt_long_rounded
    },
    {
      'id': 'advance',
      'label': 'Kasbon (Advance)',
      'icon': Icons.account_balance_wallet_rounded
    },
    {
      'id': 'revenue',
      'label': 'Pemasukan (Revenue)',
      'icon': Icons.trending_up_rounded
    },
    {'id': 'tax', 'label': 'Pajak', 'icon': Icons.gavel_rounded},
    {
      'id': 'asset',
      'label': 'Asset Register',
      'icon': Icons.inventory_2_rounded
    },
    {
      'id': 'bank_status',
      'label': 'Bank Cash',
      'icon': Icons.account_balance_rounded
    },
    {'id': 'dividend', 'label': 'Dividen', 'icon': Icons.pie_chart_rounded},
  ];

  @override
  void dispose() {
    pageController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentStep < 3) {
      if (currentStep == 1) {
        fetchPreview();
      }
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => currentStep++);
    }
  }

  void prevPage() {
    if (currentStep > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => currentStep--);
    }
  }

  Future<void> fetchPreview() async {
    setState(() => loading = true);
    try {
      final api = context.read<AuthProvider>().api;
      final res = await api.getCleanupPreview(
        years: selectedYears,
        modules: selectedModules,
      );
      setState(() {
        previewData = res['summary'] ?? [];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      showError(e.toString());
    }
  }

  Future<void> executeCleanup() async {
    setState(() => loading = true);
    try {
      final api = context.read<AuthProvider>().api;
      final res = await api.executeCleanup(
        years: selectedYears,
        modules: selectedModules,
      );

      if (mounted) {
        // Refresh providers to update sidebar badges dynamically
        context.read<SettlementProvider>().loadSettlements(notifyState: true);
        context.read<AdvanceProvider>().loadAdvances();
        context.read<NotificationProvider>().fetchNotifications(silent: true);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message'] ?? 'Data berhasil dibersihkan'),
            backgroundColor: AppTheme.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => loading = false);
      showError(e.toString());
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppTheme.danger),
    );
  }

  bool isNextEnabled() {
    if (currentStep == 0) return selectedYears.isNotEmpty;
    if (currentStep == 1) return selectedModules.isNotEmpty;
    if (currentStep == 3) return isConfirmTyped;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.surface : AppTheme.lightSurface,
      appBar: AppBar(
        title: const Text('Pembersihan Data Selektif'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                buildYearSelection(),
                buildModuleSelection(),
                buildPreviewStep(),
                buildConfirmationStep(),
              ],
            ),
          ),
          buildBottomNav(),
        ],
      ),
    );
  }

  Widget buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          bool isDone = index < currentStep;
          bool isCurrent = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone || isCurrent
                        ? AppTheme.primary
                        : AppTheme.divider.withValues(alpha: 0.2),
                  ),
                  child: Center(
                    child: isDone
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : Text('${index + 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
                if (index < 3)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isDone
                          ? AppTheme.primary
                          : AppTheme.divider.withValues(alpha: 0.2),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildYearSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Tahun',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Pilih periode tahun data yang ingin Anda bersihkan.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          buildSelectionCard(
            title: 'Semua Tahun',
            isSelected: selectedYears.contains(-1),
            onTap: () {
              setState(() {
                if (selectedYears.contains(-1)) {
                  selectedYears.remove(-1);
                } else {
                  selectedYears.clear();
                  selectedYears.add(-1);
                }
              });
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: years.map((year) {
              bool isSelected = selectedYears.contains(year);
              bool isAllSelected = selectedYears.contains(-1);

              return SizedBox(
                width: 80,
                child: buildSelectionCard(
                  title: year.toString(),
                  isSelected: isSelected,
                  isDisabled: isAllSelected,
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedYears.remove(year);
                      } else {
                        selectedYears.add(year);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildModuleSelection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Modul',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Data master seperti BNI/BCA, Kategori, dan User tidak akan dihapus.',
            style: TextStyle(color: Colors.grey),
          ),
          buildSelectionCard(
            title: 'Semua Modul',
            isSelected: selectedModules.length == modules.length,
            onTap: () {
              setState(() {
                if (selectedModules.length == modules.length) {
                  selectedModules.clear();
                } else {
                  selectedModules.clear();
                  selectedModules
                      .addAll(modules.map((m) => m['id'] as String));
                }
              });
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          ...modules.map((m) {
            bool isSelected = selectedModules.contains(m['id']);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: buildSelectionCard(
                title: m['label'],
                icon: m['icon'],
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedModules.remove(m['id']);
                    } else {
                      selectedModules.add(m['id']);
                    }
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildPreviewStep() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pratinjau Data',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Berikut adalah jumlah data yang akan dihapus dari tahun ${selectedYears.contains(-1) ? 'Semua' : selectedYears.join(', ')}.',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.card
                  : AppTheme.lightCard,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppTheme.divider.withValues(alpha: 0.1)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: previewData.length,
              separatorBuilder: (ctx, i) => const Divider(height: 1),
              itemBuilder: (ctx, i) {
                final item = previewData[i];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  title: Text(item['label'],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: Text(
                    '${item['count']} data',
                    style: const TextStyle(
                        color: AppTheme.danger, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          if (previewData.isEmpty)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(40),
                    child:
                        Text('Tidak ada data ditemukan untuk pilihan ini.'))),
        ],
      ),
    );
  }

  Widget buildConfirmationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Konfirmasi Terakhir',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.danger),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.danger.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.danger.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: AppTheme.danger, size: 32),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Tindakan ini tidak dapat dibatalkan. Semua data transaksi yang dipilih akan dihapus permanen dari database.',
                    style: TextStyle(
                        color: AppTheme.danger, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Ketik "HAPUS" untuk mengonfirmasi',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: confirmController,
            onChanged: (val) {
              setState(
                  () => isConfirmTyped = val.trim().toUpperCase() == 'HAPUS');
            },
            decoration: InputDecoration(
              hintText: 'HAPUS',
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.card
                  : AppTheme.lightCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.danger),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSelectionCard({
    required String title,
    IconData? icon,
    required bool isSelected,
    bool isDisabled = false,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: icon == null ? 4 : 16,
              vertical: icon == null ? 8 : 12,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primary.withValues(alpha: 0.15)
                  : (isDark ? AppTheme.card : AppTheme.lightCard),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primary
                    : AppTheme.divider.withValues(alpha: 0.1),
                width: 2,
              ),
            ),
            child: icon == null
                ? Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppTheme.primary
                            : (isDark ? Colors.white70 : Colors.black87),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icon,
                          color: isSelected ? AppTheme.primary : Colors.grey,
                          size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppTheme.primary
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle_rounded,
                            color: AppTheme.primary, size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget buildBottomNav() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.surface
            : AppTheme.lightSurface,
        border: Border(
            top: BorderSide(color: AppTheme.divider.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: loading ? null : prevPage,
                child: const Text('Kembali'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    currentStep == 3 ? AppTheme.danger : AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: (loading || !isNextEnabled())
                  ? null
                  : (currentStep == 3 ? executeCleanup : nextPage),
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(
                      currentStep == 3 ? 'HAPUS DATA SEKARANG' : 'Lanjutkan'),
            ),
          ),
        ],
      ),
    );
  }
}
