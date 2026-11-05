
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/profile_screen.dart';

import 'theme/app_theme.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AmaragaApp());
}

class AmaragaApp extends StatelessWidget {
  const AmaragaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amaraga',
      theme: AppTheme.lightTheme,
      home: const MainNavigation(),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;
  int refreshVersion = 0;

  Future<void> openAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (result == true && mounted) {
      setState(() {
        refreshVersion++;
      });
    }
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        key: ValueKey('home_$refreshVersion'),
        onAddTransaction: openAddTransaction,
        onViewAll: () => changePage(1),
      ),
      TransactionScreen(
        key: ValueKey('activity_$refreshVersion'),
      ),
      StatisticsScreen(
        key: ValueKey('stats_$refreshVersion'),
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: currentIndex,
        onTap: changePage,
        onAdd: openAddTransaction,
      ),
    );
  }
}
