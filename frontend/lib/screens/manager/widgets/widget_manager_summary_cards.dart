import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WidgetManagerSummaryCards extends StatelessWidget {
  final Map<String, dynamic> settlement;
  final NumberFormat idrCurrencyFormat;
  final Color Function(String) getStatusColor;

  const WidgetManagerSummaryCards({
    super.key,
    required this.settlement,
    required this.idrCurrencyFormat,
    required this.getStatusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            settlement['title'] ?? 'No Title',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Diajukan oleh: ${settlement['creator_name'] ?? 'Unknown'}'),
          Text(
            'Total Diajukan: ${idrCurrencyFormat.format(settlement['total_amount'] ?? 0)}',
          ),
          Row(
            children: [
              const Text('Status: '),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getStatusColor(
                    settlement['status'] ?? '',
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  (settlement['status'] ?? '').toString().toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(settlement['status'] ?? ''),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
