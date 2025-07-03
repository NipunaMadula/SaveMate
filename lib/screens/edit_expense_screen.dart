import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../providers/expense_provider.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;

  EditExpenseScreen({required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _category;
  late double _amount;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _title = widget.expense.title;
    _category = widget.expense.category;
    _amount = widget.expense.amount;
    _selectedDate = widget.expense.date;
  }

  void _presentDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final updated = Expense(
        id: widget.expense.id,
        title: _title,
        amount: _amount,
        category: _category,
        date: _selectedDate,
      );

      Provider.of<ExpenseProvider>(context, listen: false)
          .updateExpense(updated);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (val) => _title = val!,
                validator: (val) => val == null || val.isEmpty ? 'Enter title' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                initialValue: _amount.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
                onSaved: (val) => _amount = double.tryParse(val!) ?? 0.0,
                validator: (val) => val == null || double.tryParse(val) == null
                    ? 'Enter valid number'
                    : null,
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: predefinedCategories
                    .map((cat) => DropdownMenuItem(
                          value: cat.name,
                          child: Text('${cat.icon} ${cat.name}'),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                        'Date: ${_selectedDate.toLocal().toString().split(" ")[0]}'),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text('Change Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: Text('Update Expense')),
            ],
          ),
        ),
      ),
    );
  }
}
