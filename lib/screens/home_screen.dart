import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load expenses from database when the screen opens
    Provider.of<ExpenseProvider>(context, listen: false).loadExpenses().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('SaveMate'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : expenses.isEmpty
              ? Center(child: Text('No expenses added yet!'))
              : ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (ctx, index) {
                    final expense = expenses[index];
                    return Dismissible(
                      key: ValueKey(expense.id),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Confirm Delete'),
                            content: Text('Are you sure you want to delete this expense?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
                            ],
                          ),
                        );
                      },
                      onDismissed: (direction) {
                        Provider.of<ExpenseProvider>(context, listen: false).deleteExpense(expense.id!);
                      },
                      child: ListTile(
                        leading: Text(expense.category, style: TextStyle(fontSize: 24)),
                        title: Text(expense.title),
                        subtitle: Text(
                          '${expense.amount.toStringAsFixed(2)} LKR | ${expense.date.toLocal().toString().split(' ')[0]}',
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddExpenseScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
