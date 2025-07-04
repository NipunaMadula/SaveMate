import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/category.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    // Group by category
    final Map<String, double> categoryTotals = {};
    for (var cat in predefinedCategories) {
      final total = expenses
          .where((e) => e.category == cat.name)
          .fold(0.0, (sum, e) => sum + e.amount);
      if (total > 0) {
        categoryTotals[cat.name] = total;
      }
    }

    final List<PieChartSectionData> pieSections = [];
    final totalExpense = categoryTotals.values.fold(0.0, (a, b) => a + b);

    categoryTotals.forEach((category, amount) {
      final percent = (amount / totalExpense) * 100;
      pieSections.add(
        PieChartSectionData(
          value: amount,
          title: '${percent.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Expense Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PieChart(
          PieChartData(
            sections: pieSections,
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
    );
  }
}
