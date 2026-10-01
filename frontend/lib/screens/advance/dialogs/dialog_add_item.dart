import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/providers/settlement/settlement_provider.dart';
import 'package:expense_app/providers/advance/advance_provider.dart';
import 'package:expense_app/theme/app_theme.dart';
import 'package:expense_app/widgets/category_preview_dialog.dart';
import 'package:expense_app/utils/currency_formatter.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/advance/advance_detail_screen.dart';
import 'package:expense_app/screens/advance/advance_detail_actions.dart';
import 'package:expense_app/screens/advance/dialogs/dialog_add_category.dart';
import 'package:expense_app/models/dto/advance_requests.dart';
import 'package:flutter/foundation.dart';

extension AdvanceDetailDialogsExpenseshowAddItemDialogExt
    on AdvanceDetailScreenState {
  Future<void> showAddItemDialog(
    BuildContext context, [
    Map<String, dynamic>? item,
  ]) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isEditing = item != null;
    final reportYear = context.read<AdvanceProvider>().reportYear;
    final now = DateTime.now();
    final defaultDate = reportYear == 0 || reportYear == now.year
        ? now
        : DateTime(reportYear, 12, 31);
    final descCtrl = TextEditingController(text: item?['description']);
    final amountCtrl = TextEditingController(
      text: item?['estimated_amount'] != null
          ? NumberFormat('#,##0.###', 'id_ID')
              .format((item!['estimated_amount'] as num).abs())
          : '',
    );
    final dialogScrollCtrl = ScrollController();

    int? selectedParentId;
    Set<int> selectedSubCategoryIds = {};
    bool isNegative = item?['estimated_amount'] != null &&
        (item!['estimated_amount'] as num) < 0;

    final existingSubIds = item?['subcategory_ids'] as List?;
    if (existingSubIds != null) {
      selectedSubCategoryIds = Set<int>.from(existingSubIds.cast<int>());
    }
    List<dynamic> selectedFilePaths = List<dynamic>.from(
        (item?['evidence_path'] as String?)
                ?.split('|')
                .where((p) => p.isNotEmpty) ??
            <String>[]);
    List<String> selectedFileNames = (item?['evidence_filename'] as String?)
            ?.split('|')
            .where((f) => f.isNotEmpty)
            .toList() ??
        [];
    String? selectedSource = item?['source'];
    String selectedCurrency = item?['currency'] ?? 'IDR';
    final exchangeRateCtrl = TextEditingController(
      text: item?['currency_exchange'] != null
          ? NumberFormat('#,##0.###', 'id_ID')
              .format(item!['currency_exchange'])
          : '1',
    );
    final dateCtrl = TextEditingController(
      text: item?['date'] ?? DateFormat('yyyy-MM-dd').format(defaultDate),
    );

    // Load initial values if editing
    final catProv = context.read<SettlementProvider>();
    final allCats = uniqueById(asMapList(catProv.categories));

    if (isEditing && item['category_id'] != null) {
      final catId = item['category_id'] as int;
      for (final p in allCats) {
        if (p['id'] == catId) {
          selectedParentId = p['id'];
          break;
        }
        final children = asMapList(p['children'] as List?);
        for (final c in children) {
          if (c['id'] == catId || selectedSubCategoryIds.contains(c['id'])) {
            selectedParentId = p['id'];
            if (selectedSubCategoryIds.isEmpty) {
              selectedSubCategoryIds.add(c['id']);
            }
            break;
          }
        }
        if (selectedParentId != null) break;
      }
    }

    try {
      await showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setDialogState) {
            final prov = ctx.watch<SettlementProvider>();
            final categories = uniqueById(asMapList(prov.categories));

            // re-sync selected parent & child with fresh data from provider
            final parentIds =
                categories.map((c) => c['id']).whereType<int>().toSet();
            final effectiveParentId =
                parentIds.contains(selectedParentId) ? selectedParentId : null;

            final parent = effectiveParentId != null
                ? categories.firstWhere(
                    (c) => c['id'] == effectiveParentId,
                    orElse: () => {},
                  )
                : {};
            final children =
                uniqueById(asMapList(parent['children'] as List?));

            final childIds =
                children.map((c) => c['id']).whereType<int>().toSet();
            // Filter out subcategory IDs that no longer belong to selected parent
            selectedSubCategoryIds = selectedSubCategoryIds.intersection(
              childIds,
            );

            return AlertDialog(
              backgroundColor: cardColor(ctx),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                isEditing ? 'Edit Item Kasbon' : 'Tambah Item Kasbon',
                style: TextStyle(color: creamColor(ctx)),
              ),
              content: SizedBox(
                width: screenWidth > 600 ? 500 : screenWidth * 0.9,
                child: AppScrollbar(
                  controller: dialogScrollCtrl,
                  thumbVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    controller: dialogScrollCtrl,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 10,
                        ), // Ruang ekstra agar label terbaca
                        // dropdown kategori utama
                        DropdownButtonFormField<int>(
                          decoration: const InputDecoration(
                            labelText: 'Kategori Utama',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                          ),
                          isExpanded: true,
                          dropdownColor: cardColor(ctx),
                          style: TextStyle(color: primaryText(ctx)),
                          initialValue: effectiveParentId,
                          items: categories.map((c) {
                            final isPending = c['status'] == 'pending';
                            return DropdownMenuItem<int>(
                              value: c['id'] as int,
                              child: Text(
                                isPending
                                    ? '${c['name']} (Pending)'
                                    : c['name'],
                                style: TextStyle(
                                  color: isPending
                                      ? AppTheme.warning
                                      : primaryText(ctx),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (v) => setDialogState(() {
                            selectedParentId = v;
                            selectedSubCategoryIds = {}; // reset sub
                          }),
                        ),
                        const SizedBox(height: 12),

                        // Checklist Sub Kategori
                        if (effectiveParentId != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              children.isNotEmpty
                                  ? 'Pilih Sub Kategori:'
                                  : 'Hanya Kategori Utama',
                              style: TextStyle(
                                color: secondaryText(ctx),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (children.isNotEmpty)
                            Container(
                              constraints: const BoxConstraints(
                                maxHeight: 200,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: dividerColor(ctx)),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: children.map((c) {
                                    final subId = c['id'] as int;
                                    final isPending = c['status'] == 'pending';
                                    final isSelected =
                                        selectedSubCategoryIds.contains(subId);

                                    return Material(
                                      type: MaterialType.transparency,
                                      child: CheckboxListTile(
                                        value: isSelected,
                                        activeColor: AppTheme.primary,
                                        checkColor: Colors.white,
                                        dense: true,
                                        title: Text(
                                          isPending
                                              ? '${c['name']} (Pending)'
                                              : c['name'],
                                          style: TextStyle(
                                            color: isSelected
                                                ? AppTheme.primary
                                                : (isPending
                                                    ? AppTheme.warning
                                                    : primaryText(ctx)),
                                            fontSize: 13,
                                          ),
                                        ),
                                        onChanged: (val) {
                                          setDialogState(() {
                                            if (val == true) {
                                              selectedSubCategoryIds.add(subId);
                                            } else {
                                              selectedSubCategoryIds.remove(
                                                subId,
                                              );
                                            }
                                          });
                                        },
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          else
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                'Kategori ini tidak memiliki sub-kategori.',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],

                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextButton.icon(
                                onPressed: () => showAddCategoryDialog(
                                  ctx,
                                  setDialogState,
                                  (newCat) {
                                    final parentID = newCat['parent_id'];
                                    final catID = newCat['id'] as int;
                                    setDialogState(() {
                                      if (parentID != null) {
                                        selectedParentId = parentID;
                                        selectedSubCategoryIds.add(catID);
                                      } else {
                                        selectedParentId = catID;
                                        selectedSubCategoryIds = {};
                                      }
                                    });
                                  },
                                  parentId: selectedParentId,
                                ),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 16,
                                ),
                                label: Text(
                                  selectedParentId != null
                                      ? 'Tambah Sub-Kategori Baru'
                                      : 'Tambah Kategori Baru',
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.category_rounded,
                                color: AppTheme.primary,
                                size: 20,
                              ),
                              tooltip: 'Pratinjau Struktur Kategori',
                              onPressed: () => showCategoryPreviewDialog(
                                context,
                                context.read<SettlementProvider>().categories,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: descCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Deskripsi',
                          ),
                          style: TextStyle(color: primaryText(ctx)),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: dateCtrl,
                          decoration: InputDecoration(
                            labelText: 'Tanggal',
                            suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_today,
                                size: 18,
                              ),
                              tooltip: 'Pilih Tanggal',
                              onPressed: () async {
                                final initialDate =
                                    DateTime.tryParse(dateCtrl.text) ??
                                        defaultDate;
                                final d = await showDatePicker(
                                  context: ctx,
                                  initialDate: initialDate,
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (d != null) {
                                  dateCtrl.text = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(d);
                                }
                              },
                            ),
                          ),
                          style: TextStyle(color: primaryText(ctx)),
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),
                        // mata uang
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Mata Uang',
                                ),
                                dropdownColor: cardColor(ctx),
                                style: TextStyle(color: primaryText(ctx)),
                                initialValue: selectedCurrency,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'IDR',
                                    child: Text('IDR'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'USD',
                                    child: Text('USD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'EUR',
                                    child: Text('EUR'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'GBP',
                                    child: Text('GBP'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'JPY',
                                    child: Text('JPY'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'CNY',
                                    child: Text('CNY'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'AUD',
                                    child: Text('AUD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'HKD',
                                    child: Text('HKD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'SGD',
                                    child: Text('SGD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'TWD',
                                    child: Text('TWD'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'THB',
                                    child: Text('THB'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'MYR',
                                    child: Text('MYR'),
                                  ),
                                ],
                                onChanged: (v) => setDialogState(() {
                                  selectedCurrency = v ?? 'IDR';
                                  if (selectedCurrency == 'IDR') {
                                    exchangeRateCtrl.text = '1';
                                  }
                                }),
                              ),
                            ),
                            if (selectedCurrency != 'IDR') ...[
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: exchangeRateCtrl,
                                  decoration: const InputDecoration(
                                    labelText: 'Kurs (ke IDR)',
                                  ),
                                  style: TextStyle(color: primaryText(ctx)),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    CurrencyInputFormatter(),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Material(
                              color: isNegative
                                  ? AppTheme.danger.withValues(alpha: 0.15)
                                  : AppTheme.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              child: Semantics(
                                button: true,
                                label: 'Ubah Positif Negatif',
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () => setDialogState(() {
                                    isNegative = !isNegative;
                                  }),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    child: Text(
                                      isNegative ? '−' : '+',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isNegative
                                            ? AppTheme.danger
                                            : AppTheme.success,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: amountCtrl,
                                decoration: InputDecoration(
                                  labelText: 'Amount ($selectedCurrency)',
                                  hintText: '10.000',
                                  hintStyle: TextStyle(
                                    color: secondaryText(
                                      ctx,
                                    ).withValues(alpha: 0.5),
                                  ),
                                  prefixText: isNegative ? '- ' : null,
                                  prefixStyle: TextStyle(
                                      color: AppTheme.danger,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: TextStyle(
                                    color: isNegative
                                        ? AppTheme.danger
                                        : primaryText(ctx)),
                                keyboardType: TextInputType.number,
                                inputFormatters: [CurrencyInputFormatter()],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Tampilkan evidence lama jika ada (mode edit)
                        // Tampilkan evidence jika ada (mode edit atau baru pilih)
                        if (selectedFilePaths.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bukti Terpilih:',
                                  style: TextStyle(
                                    color: secondaryText(ctx),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ...selectedFilePaths.asMap().entries.map((
                                  entry,
                                ) {
                                  final idx = entry.key;
                                  final pathOrFile = entry.value;
                                  final name = selectedFileNames.length > idx
                                      ? selectedFileNames[idx]
                                      : (pathOrFile is String
                                          ? pathOrFile.split('/').last
                                          : pathOrFile.name);

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_file_rounded,
                                          size: 14,
                                          color: AppTheme.primary,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: TextStyle(
                                              color: primaryText(ctx),
                                              fontSize: 11,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.cancel_outlined,
                                            size: 16,
                                            color: AppTheme.danger,
                                          ),
                                          tooltip: 'Hapus File',
                                          onPressed: () => setDialogState(() {
                                            selectedFilePaths.removeAt(idx);
                                            if (selectedFileNames.length >
                                                idx) {
                                              selectedFileNames.removeAt(idx);
                                            }
                                          }),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        OutlinedButton.icon(
                          onPressed: () async {
                            try {
                              final result = await FilePicker.pickFiles(
                                type: FileType.custom,
                                allowMultiple: true,
                                withData: kIsWeb,
                                allowedExtensions: [
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'pdf',
                                  'webp',
                                ],
                              );
                              if (result != null && result.files.isNotEmpty) {
                                setDialogState(() {
                                  for (var file in result.files) {
                                    bool isDuplicate = false;
                                    for (var sf in selectedFilePaths) {
                                      if (sf is PlatformFile &&
                                          sf.name == file.name) {
                                        isDuplicate = true;
                                      } else if (sf is String &&
                                          sf == file.path) {
                                        isDuplicate = true;
                                      }
                                    }
                                    if (!isDuplicate) {
                                      selectedFilePaths.add(file);
                                      selectedFileNames.add(file.name);
                                    }
                                  }
                                });
                              }
                            } catch (e) {
                              debugPrint('FilePicker Error: $e');
                            }
                          },
                          icon: const Icon(Icons.upload_file_rounded),
                          label: Text(
                            selectedFileNames.isEmpty
                                ? (isEditing
                                    ? 'Ganti / Tambah Bukti'
                                    : 'Upload Bukti')
                                : 'Tambah Bukti Lainnya',
                          ),
                        ),
                        // Duplicated gray list removed to avoid confusion
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                if (isEditing)
                  TextButton(
                    onPressed: () => deleteItem(item['id']),
                    child: const Text(
                      'Hapus Item',
                      style: TextStyle(color: AppTheme.danger),
                    ),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: isSaving
                      ? null
                      : () async {
                          final messenger = ScaffoldMessenger.of(context);
                          // Validasi form
                          if (selectedParentId == null) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Pilih Kategori Utama'),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }

                          final parent = categories.firstWhere(
                            (c) => c['id'] == selectedParentId,
                            orElse: () => {},
                          );
                          final children = asMapList(
                            parent['children'] as List?,
                          );
                          if (children.isNotEmpty &&
                              selectedSubCategoryIds.isEmpty) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Pilih minimal satu Sub-Kategori'),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }

                          if (descCtrl.text.isEmpty) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Deskripsi harus diisi'),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }

                          if (selectedFilePaths.isEmpty) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Evidence (Bukti) wajib diisi'),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }

                          final amount = toDouble(amountCtrl.text);
                          if (amount <= 0) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Isi nominal dengan nilai yang benar.',
                                ),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }
                          final rateForValidation =
                              toDouble(exchangeRateCtrl.text);
                          final totalIdrValidation = amount * rateForValidation;

                          if (totalIdrValidation.abs() < 100) {
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Nominal ekuivalen Rupiah harus lebih dari Rp 100 atau kurang dari Rp -100',
                                ),
                                backgroundColor: AppTheme.danger,
                              ),
                            );
                            return;
                          }
                          // Apply negative sign if toggled
                          final finalAmount = isNegative ? -amount : amount;

                          // Lock mechanism - prevent double-tap
                          updateState(() => isSaving = true);

                          try {
                            final firstSubId = selectedSubCategoryIds.isNotEmpty
                                ? selectedSubCategoryIds.first
                                : null;
                            final finalCatId = firstSubId ?? selectedParentId!;
                            final subcatIds = selectedSubCategoryIds.toList();
                            final prov = context.read<AdvanceProvider>();

                            final existingPaths = selectedFilePaths
                                .where((p) =>
                                    p is String && p.startsWith('receipts/'))
                                .map((p) => p as String)
                                .toList();
                            final newPaths = selectedFilePaths
                                .where((p) =>
                                    !(p is String && p.startsWith('receipts/')))
                                .toList();

                            // For existing filenames, we need to match them with existing paths
                            final existingNames = <String>[];
                            for (var i = 0; i < selectedFilePaths.length; i++) {
                              if (selectedFilePaths[i] is String &&
                                  selectedFilePaths[i]
                                      .startsWith('receipts/')) {
                                if (i < selectedFileNames.length) {
                                  existingNames.add(selectedFileNames[i]);
                                } else {
                                  existingNames.add(
                                    (selectedFilePaths[i] as String)
                                        .split('/')
                                        .last,
                                  );
                                }
                              }
                            }

                            bool success;
                            if (item == null) {
                              final items =
                                  prov.currentAdvanceMap?['items'] as List? ??
                                      [];
                              final isFirstItem = items.isEmpty;

                              if (isFirstItem) {
                                success =
                                    await prov.saveFirstItemAndCommitAdvance(
                                  advanceId: widget.advanceId,
                                  request: AdvanceItemRequest(
                                    categoryId: finalCatId,
                                    subcategoryIds: subcatIds,
                                    description: descCtrl.text.trim(),
                                    estimatedAmount: finalAmount,
                                    date: dateCtrl.text,
                                    source: selectedSource ?? '',
                                    currency: selectedCurrency,
                                    currencyExchange: rateForValidation,
                                  ),
                                  files: newPaths.isNotEmpty ? newPaths : null,
                                );
                              } else {
                                success = await prov.addAdvanceItem(
                                  widget.advanceId,
                                  AdvanceItemRequest(
                                    categoryId: finalCatId,
                                    subcategoryIds: subcatIds,
                                    description: descCtrl.text.trim(),
                                    estimatedAmount: finalAmount,
                                    date: dateCtrl.text,
                                    source: selectedSource ?? '',
                                    currency: selectedCurrency,
                                    currencyExchange: rateForValidation,
                                  ),
                                  files: newPaths.isNotEmpty ? newPaths : null,
                                );
                              }
                            } else {
                              success = await prov.updateAdvanceItem(
                                item['id'],
                                AdvanceItemRequest(
                                  categoryId: finalCatId,
                                  subcategoryIds: subcatIds,
                                  description: descCtrl.text.trim(),
                                  estimatedAmount: finalAmount,
                                  date: dateCtrl.text,
                                  source: selectedSource ?? '',
                                  currency: selectedCurrency,
                                  currencyExchange: rateForValidation,
                                ),
                                files: newPaths.isNotEmpty ? newPaths : null,
                                existingFilePaths: existingPaths,
                                existingFileNames: existingNames,
                                status: item['status'],
                              );
                            }

                            if (success) {
                              if (ctx.mounted) Navigator.pop(ctx);
                              if (mounted) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isEditing
                                          ? 'Item diupdate ✓'
                                          : 'Item ditambahkan ✓',
                                    ),
                                    backgroundColor: AppTheme.success,
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                                prov.loadAdvance(widget.advanceId);
                              }
                            } else {
                              if (mounted) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        prov.error ?? 'Gagal menyimpan item'),
                                    backgroundColor: AppTheme.danger,
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            }
                          } finally {
                            // Unlock mechanism
                            if (mounted) updateState(() => isSaving = false);
                          }
                        },
                  child: isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Simpan'),
                ),
              ],
            );
          },
        ),
      );
    } finally {
      Future.delayed(const Duration(milliseconds: 500), () {
        descCtrl.dispose();
        amountCtrl.dispose();
        dateCtrl.dispose();
        exchangeRateCtrl.dispose();
        dialogScrollCtrl.dispose();
      });
    }
  }
}
