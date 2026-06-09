enum ExpenseCategory {
  makanan('Makanan & Minuman'),
  hiburan('Hiburan'),
  belanja('Belanja'),
  transportasi('Transportasi'),
  kesehatan('Kesehatan'),
  lainnya('Lainnya');

  final String displayName;

  const ExpenseCategory(this.displayName);

  static ExpenseCategory fromString(String category) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.displayName == category,
      orElse: () => ExpenseCategory.lainnya,
    );
  }

  static List<String> getAllCategory() {
    return ExpenseCategory.values.map((e) => e.displayName).toList();
  }
}
