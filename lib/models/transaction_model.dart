
class TransactionModel {
  final int? id;
  final String title;
  final int amount;
  final String category;
  final String note;
  final DateTime date;
  final bool isIncome;

  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    this.note = '',
    required this.date,
    required this.isIncome,
  });

  // Convert transaction data into a Map for SQLite.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'isIncome': isIncome ? 1 : 0,
    };
  }

  // Convert SQLite data into a transaction object.
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      note: map['note'] as String? ?? '',
      date: DateTime.parse(map['date'] as String),
      isIncome: (map['isIncome'] as int) == 1,
    );
  }
}
