import 'package:expense_tracker_app/cubit/expense_cubit.dart';
import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:expense_tracker_app/utils/colors.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const HomePage({super.key, required this.navigationShell});

  void _onTabTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    // HomeScreen di-keep-alive oleh indexedStack sehingga initState tidak
    // terpanggil ulang; muat ulang data agar tidak menampilkan state stale
    // dari tab Statistics yang berbagi ExpenseCubit yang sama.
    if (index == 0) {
      context.read<ExpenseCubit>().loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.tertiary,
            ],
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          onPressed: () => context.go(AppRoutes.add), 
          child: const Icon(Icons.add),
        ),
      ),
      backgroundColor: AppColors.background,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        currentIndex:
            navigationShell.currentIndex, 
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) => _onTabTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline, size: 30),
            label: 'Statistics',
          ),
        ],
      ),
      body: navigationShell,
    );
  }
}
