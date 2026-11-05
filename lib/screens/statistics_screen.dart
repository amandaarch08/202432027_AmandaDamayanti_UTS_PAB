
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../theme/app_theme.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int totalIncome = 0;
  int totalExpense = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    final results = await Future.wait([
      DatabaseHelper.instance.getTotalIncome(),
      DatabaseHelper.instance.getTotalExpense(),
    ]);

    if (!mounted) return;

    setState(() {
      totalIncome = results[0];
      totalExpense = results[1];
      isLoading = false;
    });
  }

  String formatRupiah(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    )}';
  }

  @override
  Widget build(BuildContext context) {
    final total = totalIncome + totalExpense;
    final balance = totalIncome - totalExpense;

    final incomeRatio = total == 0 ? 0.0 : totalIncome / total;
    final expenseRatio = total == 0 ? 0.0 : totalExpense / total;

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: loadStatistics,
        color: AppTheme.navy,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Your financial overview',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              // Net balance
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.navy,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'NET BALANCE',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${balance < 0 ? '-' : ''}${formatRupiah(balance.abs())}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      balance >= 0
                          ? 'Your income is higher than your expenses.'
                          : 'Your expenses are higher than your income.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Income vs Expense',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // Comparison chart
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _comparisonBar(
                      label: 'Income',
                      amount: totalIncome,
                      ratio: incomeRatio,
                      color: AppTheme.softGreen,
                    ),
                    const SizedBox(height: 24),
                    _comparisonBar(
                      label: 'Expense',
                      amount: totalExpense,
                      ratio: expenseRatio,
                      color: AppTheme.coral,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Financial summary',
                style: TextStyle(
                  color: AppTheme.navy,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              _summaryCard(
                title: 'Total Income',
                amount: totalIncome,
                icon: Icons.south_west_rounded,
                color: AppTheme.softGreen,
              ),

              const SizedBox(height: 12),

              _summaryCard(
                title: 'Total Expense',
                amount: totalExpense,
                icon: Icons.north_east_rounded,
                color: AppTheme.coral,
              ),

              const SizedBox(height: 12),

              _summaryCard(
                title: 'Net Balance',
                amount: balance,
                icon: Icons.account_balance_wallet_rounded,
                color: AppTheme.butterYellow,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _comparisonBar({
    required String label,
    required int amount,
    required double ratio,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.navy,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              formatRupiah(amount),
              style: const TextStyle(
                color: AppTheme.navy,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 12,
            backgroundColor: AppTheme.cream,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: AppTheme.navy),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppTheme.muted,
                fontSize: 13,
              ),
            ),
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${amount < 0 ? '-' : ''}${formatRupiah(amount.abs())}',
                style: const TextStyle(
                  color: AppTheme.navy,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
