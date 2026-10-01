import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/dialogs/dialog_asset_form.dart';
import 'package:expense_app/screens/management/dialogs/dialog_ndpv_table.dart';

class AssetManagementScreen extends StatefulWidget {
  final int? initialYear;
  final String? initialFilterMode;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  const AssetManagementScreen({
    super.key,
    this.initialYear,
    this.initialFilterMode,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<AssetManagementScreen> createState() => AssetManagementScreenState();
}

class AssetManagementScreenState extends State<AssetManagementScreen> {
  final dateFmt = DateFormat('yyyy-MM-dd');
  final displayFmt = DateFormat('dd-MMM-yy');
  final numberFmt = NumberFormat('#,##0', 'id_ID');

  // Controllers for Mode 2 (Projection)
  final yProjCtrl = TextEditingController();
  final mProjCtrl = TextEditingController();

  // Controllers for Mode 3 (Absolute)
  final yAbsCtrl = TextEditingController();
  final mAbsCtrl = TextEditingController();
  final dAbsCtrl = TextEditingController();

  bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
  Color cardColor(BuildContext context) =>
      isDark(context) ? AppTheme.card : AppTheme.lightCard;
  Color surfaceColor(BuildContext context) =>
      isDark(context) ? AppTheme.surface : AppTheme.lightSurface;
  Color textColor(BuildContext context) =>
      isDark(context) ? AppTheme.textPrimary : AppTheme.lightTextPrimary;
  Color secondaryTextColor(BuildContext context) =>
      isDark(context) ? AppTheme.textSecondary : AppTheme.lightTextSecondary;
  Color creamColor(BuildContext context) =>
      isDark(context) ? AppTheme.cream : AppTheme.lightTextPrimary;

  @override
  void initState() {
    super.initState();
    final assetProv = context.read<AssetProvider>();

    Future.microtask(() async {
      await assetProv.syncReportYear();
      if (mounted) loadData();
    });
  }

  @override
  void dispose() {
    yProjCtrl.dispose();
    mProjCtrl.dispose();
    yAbsCtrl.dispose();
    mAbsCtrl.dispose();
    dAbsCtrl.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    if (!mounted) return;
    final prov = context.read<AssetProvider>();

    // ✅ FIX: Only update controllers if they are empty or completely different
    // to prevent the "cursor reset/digit loss" bug while typing.
    if (yProjCtrl.text != prov.projYears) yProjCtrl.text = prov.projYears;
    if (mProjCtrl.text != prov.projMonths) mProjCtrl.text = prov.projMonths;
    if (yAbsCtrl.text != prov.absYYYY) yAbsCtrl.text = prov.absYYYY;
    if (mAbsCtrl.text != prov.absMM) mAbsCtrl.text = prov.absMM;
    if (dAbsCtrl.text != prov.absDD) dAbsCtrl.text = prov.absDD;

    await prov.loadAssets();
  }

  // ✅ Helper to validate and clamp numeric inputs
  String clampInput(String value, int max) {
    if (value.isEmpty) return '';
    int? val = int.tryParse(value);
    if (val == null) return '';
    if (val > max) return max.toString();
    return value;
  }

  String displayDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(text);
      if (dt == null) return text;
      return displayFmt.format(dt);
    } catch (_) {
      return text;
    }
  }

  Future<void> confirmDelete(Map<String, dynamic> a) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: cardColor(ctx),
        title: Text('Hapus Aset?', style: TextStyle(color: creamColor(ctx))),
        content: Text(
          'Aset "${a['name']}" akan dihapus permanen.\nData depresiasi di laporan tahunan juga akan hilang.',
          style: TextStyle(color: secondaryTextColor(ctx)),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await context.read<AssetProvider>().deleteAsset(a['id']);
        messenger.showSnackBar(
          const SnackBar(
              content: Text('Aset berhasil dihapus'),
              backgroundColor: Colors.green),
        );
      } catch (e) {
        messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget headerInput(TextEditingController ctrl, String hint, double width,
      Function(String) onChanged,
      {bool readOnly = false, Function()? onTap}) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: ctrl,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AssetProvider>();
    final assets = prov.assets;

    return Scaffold(
      backgroundColor: surfaceColor(context),
      appBar: AppBar(
        title: const Text('Manajemen Aset (Asset Register)'),
        backgroundColor: cardColor(context),
        actions: [
          // MODE 1: RECENT
          TextButton.icon(
            onPressed: () {
              prov.resetToRecent();
              loadData();
            },
            icon: Icon(Icons.history_rounded,
                color: prov.valuationMode == 'recent'
                    ? Colors.blue
                    : secondaryTextColor(context),
                size: 18),
            label: Text('Recent',
                style: TextStyle(
                    color: prov.valuationMode == 'recent'
                        ? Colors.blue
                        : secondaryTextColor(context),
                    fontSize: 12)),
          ),
          const SizedBox(width: 4),

          // FITUR BARU: REKAP GLOBAL
          IconButton(
            icon: const Icon(Icons.analytics_outlined,
                color: Colors.orange, size: 22),
            tooltip: 'Rekapitulasi Kekayaan Fisik (Multi-Asset)',
            onPressed: () => showNdpvTable(context, this, {}, isGlobal: true),
          ),

          const VerticalDivider(width: 20, indent: 15, endIndent: 15),

          // MODE 2: PROJECTION (Tahun & Bulan)
          headerInput(yProjCtrl, 'Thn', 55, (v) {
            final clamped = clampInput(v, 999);
            if (clamped != v) yProjCtrl.text = clamped;
            prov.updateProjection(years: clamped);
            loadData();
          }),
          const SizedBox(width: 4),
          headerInput(mProjCtrl, 'Bln', 55, (v) {
            final clamped = clampInput(v, 999);
            if (clamped != v) mProjCtrl.text = clamped;
            prov.updateProjection(months: clamped);
            loadData();
          }),

          const VerticalDivider(width: 20, indent: 15, endIndent: 15),

          // MODE 3: ABSOLUTE (YYYY-MM-DD)
          headerInput(yAbsCtrl, 'YYYY', 65, (v) {
            final clamped = clampInput(v, 9999);
            if (clamped != v) yAbsCtrl.text = clamped;
            prov.updateAbsolute(y: clamped);
            loadData();
          }),
          const SizedBox(width: 4),
          headerInput(mAbsCtrl, 'MM', 45, (v) {
            final clamped = clampInput(v, 12);
            if (clamped != v) mAbsCtrl.text = clamped;
            prov.updateAbsolute(m: clamped);
            loadData();
          }),
          const SizedBox(width: 4),
          headerInput(dAbsCtrl, 'DD', 45, (v) {
            final clamped = clampInput(v, 31);
            if (clamped != v) dAbsCtrl.text = clamped;
            prov.updateAbsolute(d: clamped);
            loadData();
          }),

          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAssetDialog(context, this, dateFmt),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Aset'),
      ),
      body: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : assets.isEmpty
              ? const Center(child: Text('Belum ada data aset.'))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final a = assets[index];
                    final bookValue = (a['book_value'] ?? 0).toDouble();
                    final monthlyDeprRaw =
                        (a['monthly_depreciation'] ?? 0).toDouble();
                    final assetType = (a['asset_type'] ?? '-').toString();
                    final assetCode = (a['asset_code'] ?? '-').toString();
                    final status = (a['status'] ?? 'Active').toString();

                    Color statusColor = Colors.green;
                    if (status == 'Sold') statusColor = Colors.orange;
                    if (status == 'Damaged') statusColor = Colors.red;
                    if (status == 'Disposed') statusColor = Colors.grey;
                    if (status == 'Under Maintenance') {
                      statusColor = Colors.blue;
                    }
                    if (status == 'Lost') statusColor = Colors.black54;

                    return Card(
                      color: cardColor(context),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  statusColor.withValues(alpha: 0.1),
                              child: Icon(Icons.inventory_2_outlined,
                                  color: statusColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        a['name'] ?? '-',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: textColor(context)),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: surfaceColor(context),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color:
                                                  secondaryTextColor(context)
                                                      .withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          assetCode,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color:
                                                  secondaryTextColor(context),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$assetType  ·  Beli: ${displayDate(a['purchase_date'])}  ·  ${a['useful_life_months']} bln  ·  $status',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: secondaryTextColor(context)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Sisa Masa: ${a['months_remaining'] ?? 0} bln  ·  Habis pada: ${displayDate(a['end_date'])}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: creamColor(context)
                                            .withValues(alpha: 0.8)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Depr: Rp ${numberFmt.format(monthlyDeprRaw)} / bln',
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue),
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Text(
                                        'Harga Barang: Rp ${numberFmt.format(a['purchase_price'] ?? 0)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                secondaryTextColor(context)),
                                      ),
                                      Text('·',
                                          style: TextStyle(
                                              color: secondaryTextColor(
                                                  context))),
                                      Text(
                                        'Nilai Sisa ≈ Rp ${numberFmt.format(bookValue)}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.table_chart_outlined,
                                  size: 20, color: Colors.blue),
                              tooltip: 'Lihat Tabel NDPV',
                              onPressed: () => showNdpvTable(context, this, a),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined, size: 20),
                              tooltip: 'Edit',
                              onPressed: () => showAssetDialog(context, this, dateFmt, a),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20, color: Colors.red),
                              tooltip: 'Hapus',
                              onPressed: () => confirmDelete(a),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
