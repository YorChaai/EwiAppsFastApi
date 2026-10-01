import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';

class DeadlineManagerScreen extends StatefulWidget {
  const DeadlineManagerScreen({super.key});

  @override
  State<DeadlineManagerScreen> createState() => DeadlineManagerScreenState();
}

class DeadlineRuleConfig {
  final String key;
  final String title;
  final String description;
  final IconData icon;

  const DeadlineRuleConfig({
    required this.key,
    required this.title,
    required this.description,
    required this.icon,
  });
}

class DeadlineManagerScreenState extends State<DeadlineManagerScreen> {
  static const List<DeadlineRuleConfig> ruleConfigs = [
    DeadlineRuleConfig(
      key: 'ADVANCE_COMPLETION',
      title: 'Penyelesaian Kasbon',
      description:
          'Mengingatkan Staff untuk segera menyelesaikan dan mencatat kembalian Kasbon yang sudah dicairkan.',
      icon: Icons.account_balance_wallet_rounded,
    ),
    DeadlineRuleConfig(
      key: 'ADVANCE_REVISION_APPROVAL',
      title: 'Approval Revisi Kasbon',
      description:
          'Mengingatkan Manager untuk meninjau pengajuan Kasbon yang baru saja direvisi oleh Staff.',
      icon: Icons.edit_document,
    ),
    DeadlineRuleConfig(
      key: 'SETTLEMENT_SUBMISSION',
      title: 'Pengiriman Settlement',
      description:
          'Mengingatkan Staff untuk mengirim ulang Settlement yang masih berstatus Draft atau Ditolak.',
      icon: Icons.send_time_extension_rounded,
    ),
    DeadlineRuleConfig(
      key: 'SETTLEMENT_MANAGER_REVIEW',
      title: 'Review Settlement',
      description:
          'Mengingatkan Manager untuk melakukan review terhadap item-item Settlement yang telah diajukan.',
      icon: Icons.rate_review_rounded,
    ),
    DeadlineRuleConfig(
      key: 'SETTLEMENT_FINAL_APPROVAL',
      title: 'Final Approve Settlement',
      description:
          'Mengingatkan Manager/Super Manager untuk melakukan Final Approve setelah semua item selesai direview.',
      icon: Icons.verified_rounded,
    ),
  ];

  final ApiService api = ApiService();
  bool loading = true;
  Map<String, List<int>> deadlineSettings = {};

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    loadDeadlineSettings();
  }

  Future<void> loadDeadlineSettings() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;
    api.setToken(auth.token!);

    try {
      final res = await api.getDeadlineSettings();
      if (mounted) {
        setState(() {
          deadlineSettings = {};
          for (final config in ruleConfigs) {
            final data = res[config.key];
            if (data != null && data['days'] != null) {
              deadlineSettings[config.key] = (data['days'] as List)
                  .map((e) => int.parse(e.toString()))
                  .toList();
            } else {
              deadlineSettings[config.key] = [];
            }
          }
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: '), backgroundColor: AppTheme.danger));
      }
    }
  }

  Future<void> saveSetting(String ruleKey, List<int> days) async {
    if (days.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Minimal harus ada 1 hari deadline.'),
          backgroundColor: AppTheme.danger));
      return;
    }

    days.sort();

    setState(() => loading = true);
    try {
      final res = await api.updateDeadlineSetting(ruleKey, days);
      if (mounted) {
        setState(() {
          deadlineSettings[ruleKey] = List.from(days);
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(res['message'] ?? 'Tersimpan.'),
            backgroundColor: AppTheme.success));
      }
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Error: '), backgroundColor: AppTheme.danger));
      }
    }
  }

  void showAddDayDialog(String ruleKey, List<int> currentDays) {
    final controller = TextEditingController();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('Tambah Hari Peringatan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Jumlah Hari',
                  hintText: 'Misal: 3',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  suffixText: 'Hari',
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Batal')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    final val = int.tryParse(controller.text.trim());
                    if (val != null && val > 0) {
                      if (!currentDays.contains(val)) {
                        final newDays = List<int>.from(currentDays)..add(val);
                        Navigator.pop(ctx);
                        saveSetting(ruleKey, newDays);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Hari tersebut sudah ada.'),
                                backgroundColor: AppTheme.warning));
                      }
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            ));
  }

  void removeDay(String ruleKey, List<int> currentDays, int dayToRemove) {
    final newDays = List<int>.from(currentDays)..remove(dayToRemove);
    saveSetting(ruleKey, newDays);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Deadline'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading && deadlineSettings.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  color: isDark(context)
                      ? AppTheme.surface
                      : AppTheme.lightSurface,
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      buildHeaderInfo(),
                      const SizedBox(height: 24),
                      ...ruleConfigs
                          .map((config) => buildModernRuleCard(config)),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                if (loading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
    );
  }

  Widget buildHeaderInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.1),
            AppTheme.primary.withValues(alpha: 0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_active_rounded,
                color: AppTheme.primary, size: 28),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automasi Pengingat (Reminder)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.primary),
                ),
                SizedBox(height: 6),
                Text(
                  'Atur jadwal hari keberapa sistem akan otomatis mengirimkan notifikasi peringatan berulang jika dokumen belum diproses.',
                  style: TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModernRuleCard(DeadlineRuleConfig config) {
    final days = deadlineSettings[config.key] ?? [];
    days.sort();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isDark(context) ? AppTheme.divider : Colors.grey.shade300),
      ),
      color: isDark(context) ? AppTheme.card : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(config.icon, color: AppTheme.primary, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    config.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              config.description,
              style: TextStyle(
                  fontSize: 13,
                  color: isDark(context)
                      ? Colors.grey.shade400
                      : Colors.grey.shade700,
                  height: 1.4),
            ),
            const SizedBox(height: 20),
            const Text(
              'Jadwal Peringatan (Hari Ke):',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...days.map((d) => buildDayChip(config.key, days, d)),
                InkWell(
                  onTap: () => showAddDayDialog(config.key, days),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 16, color: AppTheme.primary),
                        SizedBox(width: 4),
                        Text('Tambah',
                            style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDayChip(String ruleKey, List<int> allDays, int day) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: isDark(context) ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color:
                isDark(context) ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hari $day',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () => removeDay(ruleKey, allDays, day),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(Icons.close,
                  size: 14,
                  color: isDark(context)
                      ? Colors.grey.shade400
                      : Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
