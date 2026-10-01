import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';

class WidgetManagerApprovalTable extends StatelessWidget {
  final List expenses;
  final SettlementProvider provider;
  final Set<int> checkedExpenseIds;
  final void Function(int, bool) onToggleCheck;
  final String Function(dynamic) formatExpenseAmount;
  final IconData Function(String) getIconForStatus;
  final Color Function(String) getStatusColor;
  final void Function(Map<String, dynamic>, SettlementProvider) editExpense;
  final void Function(int, SettlementProvider) deleteExpense;
  final void Function(int, SettlementProvider) rejectExpense;
  final void Function(int, SettlementProvider) approveExpense;

  const WidgetManagerApprovalTable({
    super.key,
    required this.expenses,
    required this.provider,
    required this.checkedExpenseIds,
    required this.onToggleCheck,
    required this.formatExpenseAmount,
    required this.getIconForStatus,
    required this.getStatusColor,
    required this.editExpense,
    required this.deleteExpense,
    required this.rejectExpense,
    required this.approveExpense,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemExtent: 85.0,
      scrollCacheExtent: const ScrollCacheExtent.pixels(340),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        final expenseId = expense['id'] as int;
        final isPending = expense['status'] == 'pending';
        final isChecked = checkedExpenseIds.contains(expenseId);
        final categoryStatus =
            (expense['category_status'] ?? 'approved').toString().toLowerCase();
        final isCategoryApproved = categoryStatus == 'approved';

        final isRejected = expense['status'] == 'rejected';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: isRejected ? 4 : 2,
          color: isRejected ? Colors.red.shade50 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isRejected
                ? const BorderSide(color: Colors.red, width: 1)
                : BorderSide.none,
          ),
          child: ExpansionTile(
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPending)
                  Checkbox(
                    value: isChecked,
                    onChanged: isCategoryApproved
                        ? (value) {
                            onToggleCheck(expenseId, value ?? false);
                          }
                        : null,
                    activeColor: Colors.green,
                  ),
                const SizedBox(width: 8),
                Icon(
                  getIconForStatus(expense['status']),
                  color: getStatusColor(expense['status']),
                ),
              ],
            ),
            title: Text(expense['description'] ?? 'No Description'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(builder: (context) {
                  final catName = expense['category_name'] ?? '-';
                  String subCat = catName;
                  if (catName.contains(' > ')) {
                    subCat = catName.split(' > ').last;
                  }
                  return Text(
                    '$subCat - ${formatExpenseAmount(expense)}',
                  );
                }),
                if (!isCategoryApproved && isPending)
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text(
                      '⚠️ Kategori belum di-approve',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (expense['notes'] != null &&
                        expense['notes'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Catatan: ${expense['notes']}',
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    if (expense['status'] == 'pending')
                      Align(
                        alignment: Alignment.centerRight,
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.end,
                          children: [
                            TextButton.icon(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              label: const Text(
                                'Edit',
                                style: TextStyle(color: Colors.blue),
                              ),
                              onPressed: () => editExpense(expense, provider),
                            ),
                            TextButton.icon(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              label: const Text(
                                'Hapus',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () => deleteExpense(expenseId, provider),
                            ),
                            if (isPending) ...[
                              TextButton.icon(
                                icon: const Icon(Icons.close, color: Colors.red),
                                label: const Text(
                                  'Tolak',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () => rejectExpense(expenseId, provider),
                              ),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text('Setujui'),
                                onPressed: () => approveExpense(expenseId, provider),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
