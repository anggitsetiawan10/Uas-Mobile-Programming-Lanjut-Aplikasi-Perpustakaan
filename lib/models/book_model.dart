class Book {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String year;
  final int stock;
  final String? category;
  final String? coverImageUrl;
  final String? description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.year,
    required this.stock,
    this.category,
    this.coverImageUrl,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      year: json['year'].toString(),
      stock: json['stock'],
      category: json['category'] != null ? json['category']['name'] : null,
      coverImageUrl: json['cover_image_url'],
      description: json['description'],
    );
  }

  String get safeCoverImageUrl {
    return (coverImageUrl != null && coverImageUrl!.isNotEmpty)
        ? coverImageUrl!
        : "https://via.placeholder.com/100x150";
  }

  get coverUrl => null;

  get coverImage => null;
}
