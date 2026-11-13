class Txn {
  final int? id;
  final int amount;
  final bool income;
  final String cat;
  final String note;
  final DateTime date;

  const Txn({
    this.id,
    required this.amount,
    required this.income,
    required this.cat,
    required this.note,
    required this.date,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'amount': amount,
      'income': income ? 1 : 0,
      'cat': cat,
      'note': note,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory Txn.fromMap(Map<String, Object?> m) {
    return Txn(
      id: m['id'] as int,
      amount: m['amount'] as int,
      income: m['income'] == 1,
      cat: m['cat'] as String,
      note: m['note'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(m['date'] as int),
    );
  }
}
