import 'package:expense_tracker_app/models/expense_category.dart';
import 'package:expense_tracker_app/routes/app_router.dart';
import 'package:expense_tracker_app/utils/colors.dart';
import 'package:expense_tracker_app/utils/expense_icon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  ExpenseCategory? _selectedCategory;
  DateTime? selectedDate;

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
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

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        dateController.text = picked.toString().split(
          ' ',
        )[0]; // Format: YYYY-MM-DD
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final inpitTheme = Theme.of(context).inputDecorationTheme;
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
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
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 18,
              ),
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Text(
                      "Add Expenses",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // amount
                    TextFormField(
                      validator: (value) {
                        return null;
                      },
                      controller: amountController,
                      textAlign: TextAlign.center,
                      style: textTheme.displayLarge?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: "\$0",
                        hintStyle: textTheme.displayLarge?.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.5),
                        ),

                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildCategorySelector(),

                    const SizedBox(height: 20),
                    // title
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),

                      // title
                      child: TextFormField(
                        validator: (value) {
                          // validator
                          return null;
                        },
                        controller: titleController,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                        ),

                        decoration: InputDecoration(
                          hintText: "Judul",

                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 6, left: 18),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.divider,
                            ),
                            child: Icon(Icons.edit),
                          ),
                          prefixIconColor: AppColors.textSecondary,
                          fillColor: AppColors.surface,
                          filled: true,
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Date
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        validator: (value) {
                          // validator
                          return null;
                        },
                        controller: dateController,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate();
                        },

                        decoration: InputDecoration(
                          hintText: "Tanggal",
                          prefixIcon: Container(
                            margin: EdgeInsets.only(right: 6, left: 18),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedDate != null
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : AppColors.divider,
                            ),
                            child: Icon(
                              Icons.date_range,
                              color: selectedDate != null
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                            ),
                          ),
                          prefixIconColor: AppColors.textSecondary,
                          fillColor: AppColors.surface,
                          filled: true,
                          hintStyle: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 20),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {},
                splashColor: AppColors.lainnya,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                        AppColors.tertiary,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Save",
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
          ],
        ),
      ),
    );
  }
}
