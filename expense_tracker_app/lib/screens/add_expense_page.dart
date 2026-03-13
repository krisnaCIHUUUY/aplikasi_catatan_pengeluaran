import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  ExpenseCategory? _selectedCategory;

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void _showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // PENTING: Untuk handle overflow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // 60% dari screen height
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag Handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih Kategori',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Scrollable Category List
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: ExpenseCategory.values.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1, thickness: 0.5),
                      itemBuilder: (context, index) {
                        final category = ExpenseCategory.values[index];
                        final isSelected = _selectedCategory == category;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.getCategoryColorLight(
                                category.displayName,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(category),
                              color: AppColors.getCategoryColor(
                                category.displayName,
                              ),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            category.displayName,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 24,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedCategory = category;
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  IconData _getCategoryIcon(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.makanan:
        return ExpenseIcon.makanan;
      case ExpenseCategory.transportasi:
        return ExpenseIcon.transport;
      case ExpenseCategory.belanja:
        return ExpenseIcon.belanja;
      case ExpenseCategory.hiburan:
        return ExpenseIcon.hiburan;
      case ExpenseCategory.kesehatan:
        return ExpenseIcon.kesehatan;
      case ExpenseCategory.lainnya:
        return ExpenseIcon.lainnya;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text("Add Expense"),
            const SizedBox(height: 20),
            TextField(controller: amountController),
            const SizedBox(height: 20),
            _buildCategorySelector(),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildCategorySelector() {
    return InkWell(
      onTap: _showCategoryPicker,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _selectedCategory != null
                    ? AppColors.getCategoryColorLight(
                        _selectedCategory!.displayName,
                      )
                    : AppColors.divider,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedCategory != null
                    ? _getCategoryIcon(_selectedCategory!)
                    : Icons.category_outlined,
                color: _selectedCategory != null
                    ? AppColors.getCategoryColor(_selectedCategory!.displayName)
                    : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedCategory?.displayName ?? 'Kategori',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: _selectedCategory != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ),
            // Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
