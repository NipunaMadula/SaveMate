class Budget{
  final int? id;
  final String category;
  final double amount;

  Budget({
    this.id,
    required this.category,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      category: map['category'],
      amount: map['amount'],
    );
  }
}