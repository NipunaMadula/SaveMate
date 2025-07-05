import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/expense.dart';

class ExportHelper {
  static Future<String> exportToCSV(List<Expense> expenses) async {
    List<List<dynamic>> rows = [
      ['Title', 'Amount', 'Category', 'Date'],
    ];

    for (var e in expenses) {
      rows.add([
        e.title,
        e.amount,
        e.category,
        e.date.toLocal().toString().split(' ')[0],
      ]);
    }

    String csvData = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/expenses.csv';
    final file = File(path);
    await file.writeAsString(csvData);
    return path;
  }

  static Future<File> exportToPDF(List<Expense> expenses) async {
    final pdf = pw.Document();
    final tableData = [
      ['Title', 'Amount', 'Category', 'Date'],
      ...expenses.map((e) => [
            e.title,
            e.amount.toString(),
            e.category,
            e.date.toLocal().toString().split(' ')[0],
          ])
    ];

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Table.fromTextArray(data: tableData),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/expenses.pdf';
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
