import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/providers/master_data/bank_management_provider.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/screens/management/bank_management_screen.dart';


extension BankManagementActionsExt on BankManagementScreenState {
  Future<void> loadData() async {
    await context.read<BankManagementProvider>().loadTransactions(
          year: selectedYear,
          bankId: selectedBankId,
          mode: filterMode,
          startDate: startDate != null
              ? DateFormat('yyyy-MM-dd').format(startDate!)
              : null,
          endDate: endDate != null
              ? DateFormat('yyyy-MM-dd').format(endDate!)
              : null,
        );
  }

  Future<void> loadAdvanceData() async {
    if (!mounted) return;
    updateState(() => advanceLoading = true);
    final auth = context.read<AuthProvider>();
    advanceApi.setToken(auth.token);
    advanceApi
        .setCompany(auth.activeCompany.isEmpty ? null : auth.activeCompany);

    try {
      final userRes = await advanceApi.getUsers();
      final List<Map<String, dynamic>> loadedUsers =
          List<Map<String, dynamic>>.from(userRes['users'] ?? []);

      // Fetch all balances in one request
      final Map<int, double> loadedBalances = {};
      final Map<int, double> loadedOutstandings = {};
      final Map<int, double> loadedSaldoB = {};
      final Map<int, List<dynamic>> loadedCompositions = {};
      final Map<int, List<dynamic>> loadedHutangBreakdowns = {};

      try {
        final allBalancesRes = await advanceApi.getAllActiveAdvanceBalances();
        final balancesMap =
            allBalancesRes['balances'] as Map<String, dynamic>? ?? {};

        for (var u in loadedUsers) {
          final userId = u['id'];
          if (userId != null) {
            final userBalData =
                balancesMap[userId.toString()] as Map<String, dynamic>?;
            if (userBalData != null) {
              loadedBalances[userId] =
                  (userBalData['available_budget'] ?? 0.0).toDouble();
              loadedOutstandings[userId] =
                  (userBalData['active_advance_balance'] ?? 0.0).toDouble();
              loadedSaldoB[userId] =
                  (userBalData['total_settled'] ?? 0.0).toDouble();
              loadedCompositions[userId] =
                  List<dynamic>.from(userBalData['cash_composition'] ?? []);
              loadedHutangBreakdowns[userId] =
                  List<dynamic>.from(userBalData['breakdown'] ?? []);
            } else {
              loadedBalances[userId] = 0.0;
              loadedOutstandings[userId] = 0.0;
              loadedSaldoB[userId] = 0.0;
              loadedCompositions[userId] = [];
              loadedHutangBreakdowns[userId] = [];
            }
          }
        }
      } catch (e) {
        // Fallback or handle error
        for (var u in loadedUsers) {
          if (u['id'] != null) {
            loadedBalances[u['id']] = 0.0;
            loadedOutstandings[u['id']] = 0.0;
            loadedSaldoB[u['id']] = 0.0;
            loadedCompositions[u['id']] = [];
            loadedHutangBreakdowns[u['id']] = [];
          }
        }
      }

      if (mounted) {
        updateState(() {
          advanceUsers = loadedUsers;
          advanceBalances = loadedBalances;
          advanceOutstandings = loadedOutstandings;
          advanceSaldoB = loadedSaldoB;
          advanceCashCompositions = loadedCompositions;
          advanceHutangBreakdowns = loadedHutangBreakdowns;
          advanceLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        updateState(() => advanceLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat saldo virtual: $e'),
            backgroundColor: AppTheme.danger,
          ),
        );
      }
    }
  }

  String displayDate(dynamic value) {
    final text = (value ?? '').toString();
    if (text.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(text);
      if (dt == null) return text;
      return DateFormat('dd-MMM-yy').format(dt);
    } catch (_) {
      return text;
    }
  }

  int getBankSortIndex(String name, [int id = 0]) {
    name = name.toLowerCase().trim();

    // Cek apakah termasuk bank template standar
    int bankRank = 0;
    if (name.contains('bca')) {
      bankRank = 10;
    } else if (name.contains('mandiri')) {
      bankRank = 20;
    } else if (name.contains('bri')) {
      bankRank = 30;
    } else if (name.contains('bni')) {
      bankRank = 40;
    } else if (name.contains('ewi')) {
      bankRank = 50;
    } else if (name == 'cash' || name == 'kas') {
      bankRank = 60;
    } else {
      // Rekening baru / custom (seperti 'aa', '-', 'diofavian', dll) SELALU ditaruh di paling bawah
      return 90000 + id;
    }

    // Cek grup rekening
    int groupRank = 0;
    if (name.contains('giro')) {
      groupRank = 200;
    } else if (name.contains('bisnis')) {
      groupRank = 300;
    } else if (name.contains('tabbis') || name.contains('tabis')) {
      groupRank = 400;
    } else if (name.contains('valas')) {
      groupRank = 500;
    } else {
      groupRank = 100; // Biasa / Polos
    }

    return groupRank + bankRank;
  }
}
