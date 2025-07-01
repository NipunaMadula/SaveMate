import 'package:flutter/material.dart';
import '../models/budget.dart';
import '../helpers/db_helper.dart';

class BudgetProvider with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  Future<void> loadBudgets() async {
    _budgets = await DBHelper.fetchBudgets();
    notifyListeners();
  }

  Future<void> upsertBudget(Budget budget) async {
    await DBHelper.upsertBudget(budget);
    await loadBudgets();
  }

  Budget? getBudgetByCategory(String category) {
    return _budgets.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(category: category, amount: 0),
    );
  }
}
