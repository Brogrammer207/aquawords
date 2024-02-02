class Category {
  final dynamic category;

  Category({required this.category});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      category: map['category'] ?? '',
    );
  }
}