import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../providers/budget_provider.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final budgets = Provider.of<BudgetProvider>(context, listen: false).budgets;
    for (var cat in predefinedCategories) {
      final budget = budgets.firstWhere(
        (b) => b.category == cat.name,
        orElse: () => Budget(category: cat.name, amount: 0),
      );
      _controllers[cat.name] = TextEditingController(
        text: budget.amount.toString(),
      );
    }
  }

  void _saveBudgets() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<BudgetProvider>(context, listen: false);
      for (var cat in predefinedCategories) {
        final text = _controllers[cat.name]?.text ?? '0';
        final amount = double.tryParse(text) ?? 0;
        final budget = Budget(category: cat.name, amount: amount);
        provider.upsertBudget(budget);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Budgets saved!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Budgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              for (var cat in predefinedCategories)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextFormField(
                    controller: _controllers[cat.name],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '${cat.icon} ${cat.name} Budget (LKR)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || double.tryParse(value) == null
                            ? 'Enter valid amount'
                            : null,
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveBudgets,
                child: Text('Save Budgets'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
