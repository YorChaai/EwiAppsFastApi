import 'package:expense_app/services/api_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';


extension BankManagementDialogsshowEditAdvanceOpeningBalanceDialogExt
    on BankManagementScreenState {
  // ignore: unused_element
  Future<void> showEditAdvanceOpeningBalanceDialog(
      Map<String, dynamic> user) async {
    final formKey = GlobalKey<FormState>();
    final notesCtrl = TextEditingController(
        text: 'Inisialisasi / Sesuaikan Saldo Awal Virtual');
    final adjustmentCtrl = TextEditingController(text: '0');
    bool isPositive = true;

    try {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: surfaceColor(context),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
                  left: 24,
                  right: 24,
                  top: 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: secondaryTextColor(context)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                        Expanded(
                          child: Text(
                            'Edit Bank Advance - ${user['full_name']}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark(context)
                                    ? AppTheme.textPrimary
                                    : AppTheme.lightTextPrimary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Inisialisasi / Sesuaikan Saldo Awal Karyawan',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: secondaryTextColor(context)
                                      .withValues(alpha: 0.2)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setDialogState(() {
                                          isPositive = !isPositive;
                                        });
                                      },
                                      child: Container(
                                        height: 52,
                                        width: 52,
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: isPositive
                                              ? AppTheme.success
                                                  .withValues(alpha: 0.1)
                                              : AppTheme.danger
                                                  .withValues(alpha: 0.1),
                                          border: Border.all(
                                            color: isPositive
                                                ? AppTheme.success
                                                : AppTheme.danger,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            isPositive
                                                ? Icons.add
                                                : Icons.remove,
                                            color: isPositive
                                                ? AppTheme.success
                                                : AppTheme.danger,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: adjustmentCtrl,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          CurrencyInputFormatter()
                                        ],
                                        decoration: InputDecoration(
                                          labelText:
                                              'Jumlah Saldo Awal / Penyesuaian',
                                          hintText: '0',
                                          isDense: true,
                                          prefixText: isPositive ? '+ ' : '- ',
                                          prefixStyle: TextStyle(
                                            color: isPositive
                                                ? AppTheme.success
                                                : AppTheme.danger,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: isPositive
                                              ? AppTheme.success
                                              : AppTheme.danger,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: notesCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Catatan / Alasan Penyesuaian',
                            ),
                            validator: (v) =>
                                v!.trim().isEmpty ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) return;

                              try {
                                await advanceApi.initializeAdvanceBalance(
                                    user['id'], notesCtrl.text.trim(), []);

                                if (ctx.mounted) Navigator.pop(ctx);

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Saldo virtual awal berhasil disesuaikan!'),
                                      backgroundColor: AppTheme.success,
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Gagal menyesuaikan saldo awal: $e'),
                                      backgroundColor: AppTheme.danger,
                                    ),
                                  );
                                }
                              }
                            },
                            icon:
                                const Icon(Icons.check_circle_outline_rounded),
                            label: const Text('Simpan Saldo Awal'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                              backgroundColor: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        notesCtrl.dispose();
        adjustmentCtrl.dispose();
      });
    }
  }
}
