
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/transaction_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('amaraga.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount INTEGER NOT NULL,
        category TEXT NOT NULL,
        note TEXT NOT NULL,
        date TEXT NOT NULL,
        isIncome INTEGER NOT NULL
      )
    ''');
  }

  // Insert transaction
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await instance.database;

    return await db.insert(
      'transactions',
      transaction.toMap()..remove('id'),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all transactions
  Future<List<TransactionModel>> getTransactions() async {
    final db = await instance.database;

    final result = await db.query(
      'transactions',
      orderBy: 'date DESC, id DESC',
    );

    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  // Delete transaction
  Future<int> deleteTransaction(int id) async {
    final db = await instance.database;

    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Calculate total income
  Future<int> getTotalIncome() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM transactions WHERE isIncome = 1',
    );

    return (result.first['total'] as int?) ?? 0;
  }

  // Calculate total expense
  Future<int> getTotalExpense() async {
    final db = await instance.database;

    final result = await db.rawQuery(
      'SELECT SUM(amount) AS total FROM transactions WHERE isIncome = 0',
    );

    return (result.first['total'] as int?) ?? 0;
  }
}
