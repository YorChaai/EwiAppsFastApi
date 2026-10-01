String formatNumber(dynamic num) {
  if (num == null) return '0';
  final n = num is int ? num.toDouble() : (num as double);
  return n.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      );
}
