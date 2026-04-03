import 'package:expense_tracker_app/utils/colors.dart';
import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  // final Color color
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}