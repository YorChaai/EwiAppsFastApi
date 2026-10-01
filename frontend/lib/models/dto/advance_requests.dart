class AdvanceItemRequest {
  final int categoryId;
  final List<int> subcategoryIds;
  final String description;
  final double estimatedAmount;
  final String date;
  final String source;
  final String currency;
  final double currencyExchange;
  final String? notes;

  AdvanceItemRequest({
    required this.categoryId,
    required this.subcategoryIds,
    required this.description,
    required this.estimatedAmount,
    required this.date,
    required this.source,
    required this.currency,
    required this.currencyExchange,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'subcategory_ids': subcategoryIds,
      'description': description,
      'estimated_amount': estimatedAmount,
      'date': date,
      'source': source,
      'currency': currency,
      'currency_exchange': currencyExchange,
      'notes': notes,
    };
  }
}
