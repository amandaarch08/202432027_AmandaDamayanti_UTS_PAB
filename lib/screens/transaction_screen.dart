
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../widgets/transaction_tile.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionModel> transactions = [];
  bool isLoading = true;
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    final data = await DatabaseHelper.instance.getTransactions();

    if (!mounted) return;

    setState(() {
      transactions = data;
      isLoading = false;
    });
  }

  List<TransactionModel> get filteredTransactions {
    if (selectedFilter == 'Income') {
      return transactions.where((item) => item.isIncome).toList();
    }

    if (selectedFilter == 'Expense') {
      return transactions.where((item) => !item.isIncome).toList();
    }

    return transactions;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredTransactions;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text(
          'Activity',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadTransactions,
        color: AppTheme.navy,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Your transaction history',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),

            // Filter transaksi
            Row(
              children: ['All', 'Income', 'Expense'].map((filter) {
                final isSelected = selectedFilter == filter;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.navy
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppTheme.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 22),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (filtered.isEmpty)
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      size: 40,
                      color: AppTheme.muted,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'No transactions found',
                      style: TextStyle(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Your transactions will appear here.',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filtered.map(
                (transaction) => TransactionTile(
                  transaction: transaction,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
