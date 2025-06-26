import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../helpers/db_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => [..._expenses];

  Future<void> loadExpenses() async {
    _expenses = await DBHelper.fetchExpenses();
    notifyListeners(); 
  }

  Future<void> addExpense(Expense expense) async {
    await DBHelper.insertExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }
}
