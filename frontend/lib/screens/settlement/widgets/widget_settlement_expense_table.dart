import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/providers/auth/auth_provider.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';

class WidgetSettlementExpenseTable extends StatelessWidget {
  final List<dynamic> expenses;
  final Set<int> selectedExpenses;
  final bool canAddExpenses;
  final ScrollController expenseTableVerticalCtrl;
  final ScrollController expenseTableHorizontalCtrl;
  final Map<String, dynamic> s;
  final AuthProvider auth;

  // Callbacks
  final Widget Function(bool) buildEmptyState;
  final void Function(int, bool) onSelectChanged;
  final Widget Function(BuildContext, String) buildPendingRichText;
  final String Function(Map<String, dynamic>) formatExpenseAmount;
  final String Function(Map<String, dynamic>) expenseFundSource;
  final void Function(String, String?) showEvidence;
  final Color Function(String) getStatusColor;
  final void Function(int, List<dynamic>, String, String) showChecklistDialog;
  final Widget Function(Map<String, dynamic>, AuthProvider, Map<String, dynamic>) buildActionCell;

  const WidgetSettlementExpenseTable({
    super.key,
    required this.expenses,
    required this.selectedExpenses,
    required this.canAddExpenses,
    required this.expenseTableVerticalCtrl,
    required this.expenseTableHorizontalCtrl,
    required this.s,
    required this.auth,
    required this.buildEmptyState,
    required this.onSelectChanged,
    required this.buildPendingRichText,
    required this.formatExpenseAmount,
    required this.expenseFundSource,
    required this.showEvidence,
    required this.getStatusColor,
    required this.showChecklistDialog,
    required this.buildActionCell,
  });

  Color getCreamColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? AppTheme.cream : AppTheme.lightTextPrimary;
  Color getCardColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? AppTheme.card : AppTheme.lightCard;
  Color getDividerColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? AppTheme.divider : AppTheme.lightDivider;
  Color getSurfaceColor(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? AppTheme.surface : AppTheme.lightSurface;
  bool getIsDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return           expenses.isEmpty
              ? buildEmptyState(canAddExpenses)
              : Container(
                  decoration: BoxDecoration(
                    color: getCardColor(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: getDividerColor(context)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AppScrollbar(
                      controller: expenseTableVerticalCtrl,
                      thumbVisibility: true,
                      trackVisibility: true,
                      interactive: true,
                      child: SingleChildScrollView(
                        controller: expenseTableVerticalCtrl,
                        child: AppScrollbar(
                          controller: expenseTableHorizontalCtrl,
                          thumbVisibility: true,
                          trackVisibility: true,
                          interactive: true,
                          scrollDirection: Axis.horizontal,
                          notificationPredicate: (notification) =>
                              notification.metrics.axis == Axis.horizontal,
                          child: SingleChildScrollView(
                            controller: expenseTableHorizontalCtrl,
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              dataRowMaxHeight: double.infinity,
                              headingRowColor: WidgetStateProperty.all(
                                getSurfaceColor(context),
                              ),
                              dataRowColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return getIsDark(context)
                                      ? AppTheme.cardHover
                                      : AppTheme.lightCardHover;
                                }
                                return getCardColor(context);
                              }),
                              showCheckboxColumn: true,
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'No',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Kategori',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Subkategori',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Deskripsi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Tanggal',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                  numeric: true,
                                ),
                                DataColumn(
                                  label: Text(
                                    'Sumber Dana',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Evidence',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Aksi',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: getCreamColor(context),
                                    ),
                                  ),
                                ),
                              ],
                              rows: expenses.asMap().entries.map((entry) {
                                final idx = entry.key;
                                final exp = entry.value;
                                final expId = exp['id'] as int;

                                return DataRow(
                                  selected: selectedExpenses.contains(expId),
                                  onSelectChanged: (selected) {
                                    
                                      if (selected == true) {
                                        onSelectChanged(expId, true);
                                      } else {
                                        onSelectChanged(expId, false);
                                      }
                                    
                                  },
                                  cells: [
                                    DataCell(Text('${idx + 1}')),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 160,
                                        ),
                                        child:
                                            Text(exp['category_name'] ?? '-'),
                                      ),
                                    ),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 160,
                                        ),
                                        child: buildPendingRichText(context,
                                            exp['subcategory_name'] ?? '-'),
                                      ),
                                    ),
                                    DataCell(
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 280,
                                        ),
                                        child: Text(
                                          exp['description'] ?? '',
                                        ),
                                      ),
                                    ),
                                    DataCell(Text(exp['date'] ?? '-')),
                                    DataCell(Text(formatExpenseAmount(exp))),
                                    DataCell(Text(expenseFundSource(exp))),
                                    DataCell(
                                      exp['evidence_path'] != null
                                          ? IconButton(
                                              icon: Icon(
                                                Icons.image_rounded,
                                                color: AppTheme.accent,
                                                size: 20,
                                              ),
                                              tooltip: 'Lihat Bukti',
                                              onPressed: () => showEvidence(
                                                exp['evidence_path'],
                                                exp['evidence_filename'],
                                              ),
                                            )
                                          : const Text(
                                              '-',
                                              style: TextStyle(
                                                color: AppTheme.textSecondary,
                                              ),
                                            ),
                                    ),
                                    DataCell(
                                      Builder(
                                        builder: (context) {
                                          final status =
                                              (exp['status'] as String)
                                                  .toLowerCase();
                                          final notes = exp['notes'];
                                          final statusUpper =
                                              status.toUpperCase();
                                          Color statusColor = getStatusColor(
                                            status,
                                          );

                                          // Jika status rejected/pending/submitted dan ada checklist di notes
                                          if ((status == 'rejected' ||
                                                  status == 'pending' ||
                                                  status == 'submitted') &&
                                              notes != null) {
                                            try {
                                              List<dynamic> checklist = [];
                                              final parsedNotes =
                                                  notes is String &&
                                                          notes.startsWith('[')
                                                      ? jsonDecode(notes)
                                                      : notes;

                                              if (parsedNotes is List) {
                                                checklist = List<dynamic>.from(
                                                  parsedNotes,
                                                );
                                              }

                                              if (checklist.isNotEmpty) {
                                                final total = checklist.length;
                                                final checked = checklist
                                                    .where(
                                                      (it) =>
                                                          it['checked'] == true,
                                                    )
                                                    .length;

                                                // FIX: If there are unchecked comments, force status to REJECTED
                                                String effectiveStatus =
                                                    statusUpper;
                                                if (checked < total) {
                                                  effectiveStatus = 'REJECTED';
                                                }
                                                Color effectiveStatusColor =
                                                    getStatusColor(effectiveStatus
                                                        .toLowerCase());

                                                Widget badge = Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: effectiveStatusColor
                                                        .withValues(
                                                      alpha: 0.15,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      6,
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          effectiveStatusColor
                                                              .withValues(
                                                        alpha: 0.3,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    '$effectiveStatus (Comment $checked/$total)',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          effectiveStatusColor,
                                                    ),
                                                  ),
                                                );

                                                return InkWell(
                                                  onTap: () =>
                                                      showChecklistDialog(
                                                    expId,
                                                    checklist,
                                                    (s['status'] ?? '')
                                                        .toString(),
                                                    status,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  child: badge,
                                                );
                                              }
                                            } catch (e) {
                                              // Fallback
                                            }
                                          }

                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.15,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              statusUpper,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: statusColor,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    DataCell(buildActionCell(exp, auth, s)),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    ),
                  );
  }
}
