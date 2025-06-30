import 'book_model.dart';

class Loan {
  final int? id; // nullable, karena tidak dibutuhkan saat create
  final int bookId; // dibutuhkan saat create
  final String? status; // bisa null saat create
  final DateTime loanDate;
  final DateTime? dueDate; // optional
  final Book? book; // nullable, hanya untuk list

  Loan({
    this.id,
    required this.bookId,
    required this.loanDate,
    this.dueDate,
    this.status,
    this.book,
  });

  // Untuk mengirim data saat create
  Map<String, dynamic> toJson() => {
    'book_id': bookId,
    'loan_date': loanDate.toIso8601String(),
  };

  // Untuk parsing dari API saat menampilkan daftar pinjaman
  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      bookId: json['book_id'],
      loanDate: DateTime.parse(json['loan_date']),
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
      status: json['status'],
      book: json['book'] != null ? Book.fromJson(json['book']) : null,
    );
  }
}

// class Loan {
//   final int bookId;
//   final DateTime loanDate;
//   final DateTime? dueDate;
//   final String? status;
//
//   Loan({
//     required this.bookId,
//     required this.loanDate,
//     this.dueDate,
//     this.status,
//   });
//
//   Map<String, dynamic> toJson() => {
//     'book_id': bookId,
//     'loan_date': loanDate.toIso8601String(),
//     // 'due_date': dueDate?.toIso8601String(),
//     // 'status': status ?? 'dibooking', // ✅ fix disini
//   };
// }
