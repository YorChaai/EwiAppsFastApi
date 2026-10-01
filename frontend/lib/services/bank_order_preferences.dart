import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BankOrderPreferences {
  static const String _keyBankCashOrder = 'custom_bank_cash_order';
  static const String _keyBankAdvanceOrder = 'custom_bank_advance_order';
  static const String _keyBankCashSortMode = 'bank_cash_sort_mode';
  static const String _keyBankAdvanceSortMode = 'bank_advance_sort_mode';

  // --- Bank Cash Custom Order ---
  static Future<List<int>> getBankCashOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyBankCashOrder);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveBankCashOrder(List<int> orderIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBankCashOrder, jsonEncode(orderIds));
  }

  static Future<void> resetBankCashOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBankCashOrder);
  }

  // --- Bank Advance Custom Order ---
  static Future<List<int>> getBankAdvanceOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_keyBankAdvanceOrder);
    if (str == null || str.isEmpty) return [];
    try {
      final list = jsonDecode(str) as List<dynamic>;
      return list.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveBankAdvanceOrder(List<int> orderIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBankAdvanceOrder, jsonEncode(orderIds));
  }

  static Future<void> resetBankAdvanceOrder() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyBankAdvanceOrder);
  }

  // --- Sort Modes ('default', 'highest', 'lowest') ---
  static Future<String> getBankCashSortMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBankCashSortMode) ?? 'default';
  }

  static Future<void> saveBankCashSortMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBankCashSortMode, mode);
  }

  static Future<String> getBankAdvanceSortMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBankAdvanceSortMode) ?? 'default';
  }

  static Future<void> saveBankAdvanceSortMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBankAdvanceSortMode, mode);
  }

  // --- Bank Template Sorting Helpers ---
  static int getTemplateSortIndex(String name, [int id = 0]) {
    name = name.toLowerCase().trim();
    if (name == '-' || name == 'pilih sumber dana') return -99999;
    if (name == 'advance') return -99990;

    int bankRank = 0;
    if (name.contains('bca')) {
      bankRank = 1000;
    } else if (name.contains('mandiri')) {
      bankRank = 2000;
    } else if (name.contains('bri')) {
      bankRank = 3000;
    } else if (name.contains('bni')) {
      bankRank = 4000;
    } else if (name.contains('ewi')) {
      bankRank = 5000;
    } else if (name == 'cash' || name == 'kas') {
      bankRank = 6000;
    } else if (name == 'lainnya' || name == 'lain-lainnya') {
      return 99900 + id;
    } else {
      return 90000 + id;
    }

    // Cek grup rekening: Biasa (10) -> Giro (20) -> Bisnis (30) -> TabBis (40) -> Valas (50)
    int groupRank = 0;
    if (name.contains('giro')) {
      groupRank = 20;
    } else if (name.contains('bisnis')) {
      groupRank = 30;
    } else if (name.contains('tabbis') || name.contains('tabis')) {
      groupRank = 40;
    } else if (name.contains('valas')) {
      groupRank = 50;
    } else {
      groupRank = 10; // Akun Biasa / Polos
    }

    return bankRank + groupRank;
  }

  static int compareBankNames(String nameA, String nameB, [int idA = 0, int idB = 0]) {
    final rankA = getTemplateSortIndex(nameA, idA);
    final rankB = getTemplateSortIndex(nameB, idB);
    if (rankA != rankB) return rankA.compareTo(rankB);
    return nameA.toLowerCase().compareTo(nameB.toLowerCase());
  }

  static int _extractId(dynamic item) {
    if (item is Map) {
      final val = item['id'];
      if (val is int) return val;
      if (val != null) return int.tryParse(val.toString()) ?? 0;
    }
    return 0;
  }

  static void sortBankMaps(List<dynamic> list, {List<int>? customOrderIds}) {
    if (customOrderIds != null && customOrderIds.isNotEmpty) {
      final Map<int, int> orderMap = {
        for (int i = 0; i < customOrderIds.length; i++) customOrderIds[i]: i
      };
      list.sort((a, b) {
        final int idA = _extractId(a);
        final int idB = _extractId(b);
        final idxA = orderMap[idA] ?? 99999;
        final idxB = orderMap[idB] ?? 99999;
        if (idxA != idxB) return idxA.compareTo(idxB);
        final nameA = (a is Map ? (a['name'] ?? a['bank_name'] ?? '') : a).toString();
        final nameB = (b is Map ? (b['name'] ?? b['bank_name'] ?? '') : b).toString();
        return compareBankNames(nameA, nameB, idA, idB);
      });
    } else {
      list.sort((a, b) {
        final int idA = _extractId(a);
        final int idB = _extractId(b);
        final nameA = (a is Map ? (a['name'] ?? a['bank_name'] ?? '') : a).toString();
        final nameB = (b is Map ? (b['name'] ?? b['bank_name'] ?? '') : b).toString();
        return compareBankNames(nameA, nameB, idA, idB);
      });
    }
  }
}
