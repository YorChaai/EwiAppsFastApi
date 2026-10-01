import 'package:flutter/material.dart';
import 'package:expense_app/theme/app_theme.dart';




class FastRangePickerDialog extends StatefulWidget {
  final DateTimeRange? initialRange;
  const FastRangePickerDialog({super.key, this.initialRange});

  @override
  State<FastRangePickerDialog> createState() => FastRangePickerDialogState();
}

class FastRangePickerDialogState extends State<FastRangePickerDialog> {
  DateTime? _start;
  DateTime? _end;
  bool _pickingStart = true;

  // View states: 0 = Days, 1 = Months, 2 = Years
  int _viewMode = 0;
  late DateTime _viewDate;

  @override
  void initState() {
    super.initState();
    if (widget.initialRange != null) {
      _start = widget.initialRange!.start;
      _end = widget.initialRange!.end;
      _viewDate = _start!;
    } else {
      _viewDate = DateTime.now();
    }
  }

  void _onMonthSelected(int month) {
    setState(() {
      _viewDate = DateTime(_viewDate.year, month, 1);
      _viewMode = 0; // Selesai pilih bulan, kembali ke hari
    });
  }

  void _onYearSelected(int year) {
    setState(() {
      _viewDate = DateTime(year, _viewDate.month, 1);
      _viewMode = 1; // Setelah pilih tahun, lanjut pilih bulan
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSave = _start != null && _end != null;

    return Dialog(
      backgroundColor: isDark ? AppTheme.surface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header: Judul & Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pilih Rentang',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppTheme.textPrimary
                        : AppTheme.lightTextPrimary,
                  ),
                ),
                TextButton(
                  onPressed: canSave
                      ? () => Navigator.pop(
                          context, DateTimeRange(start: _start!, end: _end!))
                      : null,
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: canSave ? AppTheme.primary : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab Mulai - Selesai
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.card : AppTheme.lightCard,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  _buildTabButton('Mulai', _start, _pickingStart, () {
                    setState(() {
                      _pickingStart = true;
                      if (_start != null) _viewDate = _start!;
                      _viewMode = 0;
                    });
                  }),
                  _buildTabButton('Selesai', _end, !_pickingStart, () {
                    setState(() {
                      _pickingStart = false;
                      if (_end != null) _viewDate = _end!;
                      _viewMode = 0;
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Kalender Area
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildPickerContent(isDark),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerContent(bool isDark) {
    if (_viewMode == 0) {
      // MODE HARI (GRID KUSTOM)
      return Column(
        key: const ValueKey('day_view'),
        children: [
          _buildHeaderWithNav(isDark),
          const SizedBox(height: 8),
          _buildDayGrid(isDark),
        ],
      );
    } else if (_viewMode == 1) {
      // MODE BULAN
      return Column(
        key: const ValueKey('month_view'),
        children: [
          _buildHeader(() => setState(() => _viewMode = 2),
              _viewDate.year.toString(), isDark),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
            ),
            itemCount: 12,
            itemBuilder: (context, i) {
              final months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'Mei',
                'Jun',
                'Jul',
                'Agu',
                'Sep',
                'Okt',
                'Nov',
                'Des'
              ];
              final isSelected = _viewDate.month == i + 1;
              return Center(
                child: TextButton(
                  onPressed: () => _onMonthSelected(i + 1),
                  style: TextButton.styleFrom(
                    backgroundColor: isSelected
                        ? AppTheme.primary.withValues(alpha: 0.15)
                        : null,
                  ),
                  child: Text(months[i],
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primary
                            : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      )),
                ),
              );
            },
          ),
        ],
      );
    } else {
      // MODE TAHUN
      return Column(
        key: const ValueKey('year_view'),
        children: [
          _buildHeader(
              () => setState(() => _viewMode = 1), 'Pilih Tahun', isDark),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2,
              ),
              itemCount: 21,
              itemBuilder: (context, i) {
                final year = 2020 + i;
                final isSelected = _viewDate.year == year;
                return Center(
                  child: TextButton(
                    onPressed: () => _onYearSelected(year),
                    style: TextButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppTheme.primary.withValues(alpha: 0.15)
                          : null,
                    ),
                    child: Text(year.toString(),
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primary
                              : (isDark ? Colors.white70 : Colors.black87),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        )),
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }

  Widget _buildHeaderWithNav(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left_rounded),
          onPressed: () => setState(() {
            _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
          }),
        ),
        _buildHeader(() => setState(() => _viewMode = 2),
            _viewDate.year.toString(), isDark),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded),
          onPressed: () => setState(() {
            _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
          }),
        ),
      ],
    );
  }

  Widget _buildDayGrid(bool isDark) {
    final daysInMonth =
        DateUtils.getDaysInMonth(_viewDate.year, _viewDate.month);
    final firstDayOffset =
        DateTime(_viewDate.year, _viewDate.month, 1).weekday % 7;
    final totalCells = daysInMonth + firstDayOffset;

    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Column(
      children: [
        // Weekday labels
        Row(
          children: weekDays
              .map((d) => Expanded(
                    child: Center(
                        child: Text(d,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey))),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7),
          itemCount: totalCells,
          itemBuilder: (context, i) {
            if (i < firstDayOffset) return const SizedBox();

            final day = i - firstDayOffset + 1;
            final date = DateTime(_viewDate.year, _viewDate.month, day);

            // Check if date is in range
            bool isStart = _start != null && DateUtils.isSameDay(date, _start!);
            bool isEnd = _end != null && DateUtils.isSameDay(date, _end!);
            bool isInRange = _start != null &&
                _end != null &&
                date.isAfter(_start!) &&
                date.isBefore(_end!);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (_pickingStart) {
                    _start = date;
                    if (_end != null && _start!.isAfter(_end!)) {
                      _end = null;
                    }
                    _pickingStart = false; // Auto switch ke selesai
                  } else {
                    _end = date;
                    if (_start != null && _end!.isBefore(_start!)) {
                      _start = _end;
                      _end = null;
                    }
                  }
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Range Fill Background (diperhalus)
                  if (isInRange || isStart || isEnd)
                    Container(
                      margin: EdgeInsets.only(
                        left: isStart ? 18 : 0,
                        right: isEnd ? 18 : 0,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.horizontal(
                          left:
                              isStart ? const Radius.circular(20) : Radius.zero,
                          right:
                              isEnd ? const Radius.circular(20) : Radius.zero,
                        ),
                      ),
                    ),

                  // Circle for start/end
                  if (isStart || isEnd)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: (isStart || isEnd)
                          ? Colors.white
                          : (isDark ? Colors.white : Colors.black),
                      fontWeight: (isStart || isEnd)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader(VoidCallback onTap, String label, bool isDark) {
    String subLabel = '';
    if (_viewMode == 0) subLabel = '${_getMonthName(_viewDate.month)} ';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$subLabel$label',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_drop_down, color: AppTheme.primary),
            ],
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    return [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ][month - 1];
  }

  Widget _buildTabButton(
      String label, DateTime? date, bool active, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: active
                      ? Colors.white70
                      : (isDark
                          ? AppTheme.textSecondary
                          : AppTheme.lightTextSecondary),
                ),
              ),
              Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : "-- / -- / --",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: active
                      ? Colors.white
                      : (isDark
                          ? AppTheme.textPrimary
                          : AppTheme.lightTextPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
