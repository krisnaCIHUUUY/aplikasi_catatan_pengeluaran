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
    switch (category.toLowerCase()) {
      case 'Makanan & Minuman':
        return ExpenseCategory.makanan;
      case 'Transportasi':
        return ExpenseCategory.transportasi;
      case 'Belanja':
        return ExpenseCategory.belanja;
      case 'Hiburan':
        return ExpenseCategory.hiburan;
      case 'Kesehatan':
        return ExpenseCategory.kesehatan;
      default:
        return ExpenseCategory.lainnya;
    }
  }

  static List<String> getAllCategory() {
    return ExpenseCategory.values.map((e) => e.displayName).toList();
  }
}
