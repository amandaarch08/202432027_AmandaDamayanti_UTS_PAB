
import 'package:flutter/material.dart';

import '../models/transaction_model.dart';
import '../theme/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  String formatRupiah(int amount) {
    final formatted = amount.abs().toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }

  IconData getCategoryIcon() {
    switch (transaction.category.toLowerCase()) {
      case 'food':
      case 'makanan':
        return Icons.restaurant_rounded;

      case 'transport':
      case 'transportasi':
        return Icons.directions_car_rounded;

      case 'shopping':
      case 'belanja':
        return Icons.shopping_bag_rounded;

      case 'salary':
      case 'gaji':
        return Icons.account_balance_wallet_rounded;

      case 'entertainment':
      case 'hiburan':
        return Icons.movie_rounded;

      default:
        return Icons.receipt_long_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isIncome
                    ? AppTheme.softGreen.withValues(alpha: 0.25)
                    : AppTheme.coral.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                getCategoryIcon(),
                color: AppTheme.navy,
                size: 21,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: const TextStyle(
                      color: AppTheme.navy,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    transaction.category,
                    style: const TextStyle(
                      color: AppTheme.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Text(
              '${isIncome ? '+' : '-'}${formatRupiah(transaction.amount)}',
              style: TextStyle(
                color: isIncome
                    ? const Color(0xFF638C68)
                    : AppTheme.navy,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
