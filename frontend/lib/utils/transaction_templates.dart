class TxTemplates {
  static const String addRealCash = 'Penambahan Saldo Kas Riil';
  static const String subRealCash = 'Pengurangan Saldo Kas Riil';
  static const String initVirtual = 'Penyesuaian Saldo Virtual';

  static String allocationNotes(String directionLabel, String targetUserName,
      String currentUserName, String notes) {
    String base;
    if (targetUserName == currentUserName) {
      base = '$directionLabel - $targetUserName';
    } else {
      base = '$directionLabel - $targetUserName (oleh $currentUserName)';
    }

    final cleanNotes = notes.trim();
    final defaultSkipLabels = [
      initVirtual.toLowerCase(),
      'terima alokasi',
      'tarik alokasi',
      directionLabel.toLowerCase(),
    ];

    if (cleanNotes.isNotEmpty &&
        !defaultSkipLabels.contains(cleanNotes.toLowerCase())) {
      return '$base: $cleanNotes';
    }
    return base;
  }
}

