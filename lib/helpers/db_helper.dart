import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';
import '../models/budget.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> getDatabase() async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'savemate.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            category TEXT,
            date TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE budgets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT,
            amount REAL
          );
        ''');
      },
    );

    return _db!;
  }

    static Future<void> insertExpense(Expense expense) async {
    final db = await getDatabase();
    await db.insert('expenses', expense.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

    static Future<List<Expense>> fetchExpenses() async {
    final db = await getDatabase();
    final data = await db.query('expenses');
    return data.map((e) => Expense.fromMap(e)).toList();
  }

    static Future<void> upsertBudget(Budget budget) async {
    final db = await getDatabase();
    final existing = await db.query(
      'budgets',
      where: 'category = ?',
      whereArgs: [budget.category],
    );

    if (existing.isNotEmpty) {
      await db.update('budgets', budget.toMap(), where: 'category = ?', whereArgs: [budget.category]);
    } else {
      await db.insert('budgets', budget.toMap());
    }
  }

}
