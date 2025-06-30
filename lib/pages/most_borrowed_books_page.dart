import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'book_detail.dart';

class MostBorrowedBooksPage extends StatefulWidget {
  @override
  _MostBorrowedBooksPageState createState() => _MostBorrowedBooksPageState();
}

class _MostBorrowedBooksPageState extends State<MostBorrowedBooksPage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = BookService().fetchMostBorrowedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🔥 Paling Banyak Dipinjam", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Book>>(
        future: _booksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("❌ Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("📭 Tidak ada buku."));
          }

          final books = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.safeCoverImageUrl,
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 90,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                  title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${book.author} • ${book.year}'),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo.shade300),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailPage(book: book),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/book_model.dart';
// import '../services/book_service.dart';
// import 'book_detail.dart';
//
// class MostBorrowedBooksPage extends StatefulWidget {
//   @override
//   _MostBorrowedBooksPageState createState() => _MostBorrowedBooksPageState();
// }
//
// class _MostBorrowedBooksPageState extends State<MostBorrowedBooksPage> {
//   late Future<List<Book>> _booksFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _booksFuture = BookService().fetchMostBorrowedBooks();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("🔥 Paling Banyak Dipinjam", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.indigo,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: FutureBuilder<List<Book>>(
//         future: _booksFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text("❌ Error: ${snapshot.error}"));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text("📭 Tidak ada buku."));
//           }
//
//           final books = snapshot.data!;
//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               return Card(
//                 margin: const EdgeInsets.symmetric(vertical: 8),
//                 child: ListTile(
//                   leading: Image.network(book.safeCoverImageUrl, width: 60, fit: BoxFit.cover),
//                   title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                   subtitle: Text('${book.author} • ${book.year}'),
//                   onTap: () {
//                     Navigator.push(context, MaterialPageRoute(
//                       builder: (_) => BookDetailPage(book: {
//                         "judul": book.title,
//                         "pengarang": book.author,
//                         "tahun": book.year,
//                         "cover": book.safeCoverImageUrl,
//                         "deskripsi": book.description,
//                       }),
//                     ));
//                   },
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
