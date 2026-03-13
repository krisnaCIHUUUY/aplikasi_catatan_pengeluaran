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
      case 'makanan':
        return ExpenseCategory.makanan;
      case 'transport':
        return ExpenseCategory.transportasi;
      case 'belanja':
        return ExpenseCategory.belanja;
      case 'hiburan':
        return ExpenseCategory.hiburan;
      case 'kesehatan':
        return ExpenseCategory.kesehatan;
      default:
        return ExpenseCategory.lainnya;
    }
  }

  static List<String> getAllCategory() {
    return ExpenseCategory.values.map((e) => e.displayName).toList();
  }
}
