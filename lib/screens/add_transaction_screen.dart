
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/transaction_model.dart';
import '../theme/app_theme.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  bool isIncome = false;
  String selectedCategory = 'Food';
  DateTime selectedDate = DateTime.now();
  bool isSaving = false;

  final List<String> categories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Salary',
    'Other',
  ];

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    try {
      final transaction = TransactionModel(
        title: titleController.text.trim(),
        amount: int.parse(amountController.text),
        category: selectedCategory,
        note: noteController.text.trim(),
        date: selectedDate,
        isIncome: isIncome,
      );

      await DatabaseHelper.instance.insertTransaction(transaction);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save transaction: $e'),
        ),
      );

      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text(
          'Add Transaction',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Transaction type',
              style: TextStyle(
                color: AppTheme.navy,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            // Income and Expense selector
            Row(
              children: [
                Expanded(
                  child: _typeButton(
                    label: 'Income',
                    value: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _typeButton(
                    label: 'Expense',
                    value: false,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            _fieldLabel('Transaction name'),
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'e.g. Monthly allowance',
                prefixIcon: Icon(Icons.edit_outlined),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter transaction name';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _fieldLabel('Amount (Rupiah)'),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 50000',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
              validator: (value) {
                final amount = int.tryParse(value ?? '');

                if (amount == null || amount <= 0) {
                  return 'Enter a valid amount';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            _fieldLabel('Category'),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedCategory = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            _fieldLabel('Date'),
            InkWell(
              onTap: selectDate,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: AppTheme.navy,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${selectedDate.day.toString().padLeft(2, '0')}/'
                      '${selectedDate.month.toString().padLeft(2, '0')}/'
                      '${selectedDate.year}',
                      style: const TextStyle(
                        color: AppTheme.navy,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.muted,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _fieldLabel('Note (Optional)'),
            TextFormField(
              controller: noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add a little description...',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: isSaving ? null : saveTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.navy,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: isSaving
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Save Transaction',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.navy,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _typeButton({
    required String label,
    required bool value,
  }) {
    final isSelected = isIncome == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          isIncome = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.butterYellow
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppTheme.navy
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.navy,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
