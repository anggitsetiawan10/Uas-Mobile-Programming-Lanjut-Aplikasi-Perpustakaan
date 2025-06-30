import 'book_model.dart';

class Review {
  final int id;
  final int bookId;
  final String bookTitle;
  final String? coverImageUrl;
  final int rating;
  final String comment;

  Review({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    this.coverImageUrl,
    required this.rating,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      bookId: json['book_id'],
      bookTitle: json['book']['title'] ?? '',
      coverImageUrl: json['book']['cover_image_url'] ?? '',
      rating: json['rating'],
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'book_id': bookId,
    'rating': rating,
    'comment': comment,
  };
}

// ✅ Tambahkan di luar class Review
extension ReviewToBook on Review {
  Book toBook() {
    return Book(
      id: bookId,
      title: bookTitle,
      author: '', // Tidak tersedia dari review
      publisher: '',
      year: '',
      stock: 0,
      category: null,
      coverImageUrl: coverImageUrl,
      description: '',
    );
  }
}
