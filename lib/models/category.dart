class Category {
  final String name;
  final String icon;

  Category({
    required this.name,
    required this.icon,
  });
}

  final List<Category> predefinedCategories = [
    Category(name: 'Food', icon: '🍔'),
    Category(name: 'Transport', icon: '🚌'),
    Category(name: 'Health', icon: '💊'),
    Category(name: 'Utilities', icon: '💡'),
    Category(name: 'Entertainment', icon: '🎬'),
    Category(name: 'Shopping', icon: '🛍️'),
    Category(name: 'Others', icon: '📦'),
  ];