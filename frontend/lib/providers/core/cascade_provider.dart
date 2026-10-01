import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Provider Data
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/providers/transactions/revenue_provider.dart';
import 'package:expense_app/providers/master_data/tax_provider.dart';
import 'package:expense_app/providers/transactions/dividend_provider.dart';
import 'package:expense_app/providers/transactions/asset_provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/master_data/bank_status_provider.dart';

/// ============================================================================
/// CASCADE RELATION MAPPING (Dokumentasi Relasi)
/// ============================================================================
///
/// 1. GROUP [laporan] (Saling Sinkron):
///    - Laporan Summary (ReportScreen)
///    - Laporan Tahunan (AnnualReportScreen)
///    - Manajemen Revenue, Tax, Dividend, Asset
///    - Status Bank
///    -> Perubahan tahun di salah satu halaman ini akan mengubah semuanya.
///
/// 2. PAGE [Settlement] (Independen):
///    - Memiliki state tahun sendiri di SettlementProvider (_filterYear).
///    - TIDAK terpengaruh oleh perubahan di Grup Laporan atau Kasbon.
///    - Hanya ikut berubah jika fitur "GABUNG" aktif di UI-nya.
///
/// 3. PAGE [Kasbon] (Independen):
///    - Memiliki state tahun sendiri di AdvanceProvider (_filterYear).
///    - TIDAK terpengaruh oleh perubahan di Grup Laporan atau Settlement.
///    - Hanya ikut berubah jika fitur "GABUNG" aktif di UI-nya.
///
/// 4. GLOBAL SETTINGS:
///    - Mengubah "Default Tahun Laporan" di Settings akan mereset SEMUA halaman
///      ke tahun tersebut sebagai titik awal baru.
/// ============================================================================

enum CascadeGroup {
  laporan, // Grup Laporan & Manajemen
  settings, // Pemicu reset global dari Settings
}

/// CascadeProvider: Centralized State Management (Mediator)
///
/// Bertugas menjembatani dan menyinkronkan state (seperti filter tahun dan mode)
/// antar halaman yang berbeda tanpa harus membuat spaghetti code di UI.
class CascadeProvider extends ChangeNotifier {
  /// Sync tahun untuk Grup Laporan (Summary, Tahunan, Revenue, Tax, Dividend, Asset)
  /// Ini tidak akan merusak tampilan list Kasbon & Settlement berkat pemisahan
  /// _reportYear dan _filterYear di masing-masing provider.
  void syncReportYear(BuildContext context, int year, {String? mode}) {
    // ✅ Use microtask to ensure this happens after the current build cycle
    // This prevents "setState() or markNeedsBuild() called during build" errors.
    Future.microtask(() {
      if (!context.mounted) return;

      // 1. Sinkronkan provider pendukung Laporan
      context.read<RevenueProvider>().setReportYear(year, reload: false);
      context.read<TaxProvider>().setReportYear(year, reload: false);
      context.read<DividendProvider>().setReportYear(year, reload: false);
      context.read<AssetProvider>().setReportYear(year, reload: false);
      context.read<BankManagementProvider>().setReportYear(year);
      context.read<BankStatusProvider>().setReportYear(year);

      // 2. Sinkronkan State Laporan di Settlement dan Advance (HANYA Report Year, BUKAN List Filter)
      context
          .read<SettlementProvider>()
          .setReportYear(year, mode: mode, reload: false);
      context
          .read<AdvanceProvider>()
          .setReportYear(year, mode: mode, reload: false);
    });
  }

  /// Sinkronisasi penuh saat Default Root Year diganti dari halaman Settings
  void syncAllFromSettings(BuildContext context, int year) {
    // Mode dikembalikan ke report sebagai default
    const defaultMode = 'report';

    final sProv = context.read<SettlementProvider>();
    final aProv = context.read<AdvanceProvider>();

    sProv.setFilterMode(defaultMode, reload: false);
    aProv.setFilterMode(defaultMode, reload: false);

    // Panggil setReportYear (sekarang sudah aman, tidak menimpa otomatis kecuali kita instruksikan reset filter)
    sProv.setReportYear(year, reload: false);
    aProv.setReportYear(year, reload: false);

    // PAKSA update List Filter karena ini perintah dari Settings
    sProv.setFilterYear(year, defaultMode, reload: true);
    aProv.setFilterYear(year, defaultMode, reload: true);

    // Update Grup Laporan
    context.read<RevenueProvider>().setReportYear(year, reload: true);
    context.read<TaxProvider>().setReportYear(year, reload: true);
    context.read<DividendProvider>().setReportYear(year, reload: true);
    context.read<AssetProvider>().setReportYear(year, reload: true);
    context.read<BankManagementProvider>().setReportYear(year);
    context.read<BankStatusProvider>().setReportYear(year);
  }
}
