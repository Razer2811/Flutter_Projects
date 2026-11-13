class TransactionModel {
  final int? id;
  final String title;
  final int amount;
  final String type;
  final String category;
  final String note;
  final DateTime createdAt;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.note = '',
    required this.createdAt,
  });

  // Chuyển đối tượng thành Map để lưu SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Chuyển dữ liệu SQLite thành đối tượng
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      note: map['note'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
