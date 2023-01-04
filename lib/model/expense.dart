import 'dart:ffi';

class ExpenseFields {
  static final String date = 'Date';
  static final String store = 'Store';
  static final String amount = 'Amount';
  static final String category = 'Category';
  static final String details = 'Details (Optional)';

  static List<String> getFields() => [date, store, amount, category, details];
}

class Expense {

  final String dateOfPurchase;
  final String store;
  final String amount;
  final String category;
  final String details;

  const Expense({
    required this.dateOfPurchase,
    required this.store,
    required this.amount,
    required this.category,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
    ExpenseFields.date: dateOfPurchase,
    ExpenseFields.store: store,
    ExpenseFields.amount: amount,
    ExpenseFields.category: category,
    ExpenseFields.details: details,
  };
}