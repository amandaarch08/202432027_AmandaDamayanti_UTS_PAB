
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_tile.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onAddTransaction;
  final VoidCallback onViewAll;

  const HomeScreen({
    super.key,
    required this.onAddTransaction,
    required this.onViewAll,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> transactions = [];
  int totalIncome = 0;
  int totalExpense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DatabaseHelper.instance.getTransactions();
    final income = await DatabaseHelper.instance.getTotalIncome();
    final expense = await DatabaseHelper.instance.getTotalExpense();

    if (!mounted) return;

    setState(() {
      transactions = data;
      totalIncome = income;
      totalExpense = expense;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: loadData,
          color: AppTheme.navy,
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good day,',
                        style: TextStyle(
                          color: AppTheme.muted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Amanda! 👋',
                        style: TextStyle(
                          color: AppTheme.navy,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.butterYellow,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: AppTheme.navy,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Balance Card
              BalanceCard(
                balance: balance,
                income: totalIncome,
                expense: totalExpense,
              ),

              const SizedBox(height: 30),

              // Quick Action
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick action',
                    style: TextStyle(
                      color: AppTheme.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: widget.onAddTransaction,
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add new'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.navy,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Add Transaction Button
              GestureDetector(
                onTap: widget.onAddTransaction,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.butterYellow,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppTheme.navy,
                        size: 25,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add your transaction',
                          style: TextStyle(
                            color: AppTheme.navy,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppTheme.navy,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent transactions',
                    style: TextStyle(
                      color: AppTheme.navy,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onViewAll,
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppTheme.muted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (transactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.receipt_long_rounded,
                        size: 35,
                        color: AppTheme.muted,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No transactions yet',
                        style: TextStyle(
                          color: AppTheme.navy,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Start recording your first transaction.',
                        style: TextStyle(
                          color: AppTheme.muted,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...transactions.take(5).map(
                  (transaction) => TransactionTile(
                    transaction: transaction,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
