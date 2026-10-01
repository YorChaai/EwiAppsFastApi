import 'package:flutter/material.dart';
import 'package:expense_app/screens/management/revenue_management_screen.dart';


extension RevenueManagementTablesExt on RevenueManagementScreenState {
  Widget buildCell(
    dynamic value,
    double width, {
    bool isHeader = false,
    bool isLast = false,
    Alignment alignment = Alignment.center,
    bool noLeftBorder = false,
    bool noBottomBorder = false,
  }) {
    return Container(
      width: width,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          left: noLeftBorder
              ? BorderSide.none
              : BorderSide(color: dividerColor(context), width: 0.5),
          right: isLast
              ? BorderSide.none
              : BorderSide(color: dividerColor(context), width: 0.5),
          bottom: (noBottomBorder || isHeader)
              ? BorderSide.none
              : BorderSide(color: dividerColor(context), width: 0.5),
        ),
      ),
      alignment: alignment,
      child: value is Widget
          ? value
          : Text(
              value.toString(),
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: isHeader ? 13 : 12,
                color: isHeader ? creamColor(context) : textColor(context),
              ),
              textAlign: alignment == Alignment.center
                  ? TextAlign.center
                  : alignment == Alignment.centerRight
                      ? TextAlign.right
                      : TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }
}
