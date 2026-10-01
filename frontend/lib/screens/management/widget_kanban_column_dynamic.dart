import 'package:flutter/material.dart';
import 'package:expense_app/widgets/app_scrollbar.dart';
import 'package:expense_app/screens/management/category_tabular_screen.dart';


extension CategoryTabularScreenKanbanColumnDynamicExt
    on CategoryTabularScreenState {
  Widget buildKanbanColumnDynamic(
    Map<String, dynamic> group,
    List<Map<String, dynamic>> items,
    Color color,
    ScrollController controller,
    Function(Map<String, dynamic>) onMove,
    Function(int, int) onReorder,
  ) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group['name'].toString().toUpperCase(),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${items.length}',
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      'Kosong',
                      style: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.5),
                          fontSize: 12),
                    ),
                  )
                : AppScrollbar(
                    controller: controller,
                    thumbVisibility: true,
                    interactive: true,
                    scrollbarOrientation: ScrollbarOrientation.left,
                    child: ReorderableListView.builder(
                      scrollController: controller,
                      onReorderItem: onReorder,
                      buildDefaultDragHandles: false,
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      itemCount: items.length,
                      itemBuilder: (ctx, idx) {
                        final cat = items[idx];
                        return Card(
                          key: ValueKey('kanban_${cat['id']}'),
                          color: surfaceColor(context),
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color:
                                  dividerColor(context).withValues(alpha: 0.5),
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            leading: ReorderableDragStartListener(
                              index: idx,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.drag_handle_rounded,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                            title: Text(
                              '${cat['name']} (${cat['code'] ?? ''})',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward_rounded,
                                  size: 16),
                              onPressed: () => onMove(cat),
                              tooltip: 'Pindah grup',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
