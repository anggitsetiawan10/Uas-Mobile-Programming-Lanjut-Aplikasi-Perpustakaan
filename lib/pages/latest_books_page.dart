import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'book_detail.dart';

class LatestBooksPage extends StatefulWidget {
  @override
  _LatestBooksPageState createState() => _LatestBooksPageState();
}

class _LatestBooksPageState extends State<LatestBooksPage>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchBooks();
  }

  void _fetchBooks() {
    setState(() {
      _booksFuture = BookService().fetchLatestBooks();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchBooks();
    }
  }

  Future<void> _refreshBooks() async {
    _fetchBooks();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("📚 Buku Terbaru", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBooks,
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('❌ Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('📭 Tidak ada buku terbaru.'));
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
                  elevation: 4,
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
                    title: Text(
                      book.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${book.author} • ${book.year}',
                              style: const TextStyle(fontSize: 13)),
                          Text('Genre: ${book.category ?? "-"}',
                              style: const TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      ),
                    ),
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
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/book_model.dart';
// import '../services/book_service.dart';
// import 'book_detail.dart';
//
// class LatestBooksPage extends StatefulWidget {
//   @override
//   _LatestBooksPageState createState() => _LatestBooksPageState();
// }
//
// class _LatestBooksPageState extends State<LatestBooksPage>
//     with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
//   late Future<List<Book>> _booksFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _fetchBooks();
//   }
//
//   void _fetchBooks() {
//     setState(() {
//       _booksFuture = BookService().fetchLatestBooks();
//     });
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _fetchBooks();
//     }
//   }
//
//   Future<void> _refreshBooks() async {
//     _fetchBooks();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("📚 Buku Terbaru", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.indigo,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _refreshBooks,
//         child: FutureBuilder<List<Book>>(
//           future: _booksFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('❌ Terjadi kesalahan: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('📭 Tidak ada buku terbaru.'));
//             }
//
//             final books = snapshot.data!;
//             return ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: books.length,
//               itemBuilder: (context, index) {
//                 final book = books[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//                   elevation: 4,
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.all(12),
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         book.safeCoverImageUrl,
//                         width: 60,
//                         height: 90,
//                         fit: BoxFit.cover,
//                         errorBuilder: (_, __, ___) => Container(
//                           width: 60,
//                           height: 90,
//                           color: Colors.grey[300],
//                           child: const Icon(Icons.broken_image, size: 40),
//                         ),
//                       ),
//                     ),
//                     title: Text(
//                       book.title,
//                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     subtitle: Padding(
//                       padding: const EdgeInsets.only(top: 4.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('${book.author} • ${book.year}',
//                               style: const TextStyle(fontSize: 13)),
//                           Text('Genre: ${book.category ?? "-"}',
//                               style: const TextStyle(fontSize: 12, color: Colors.black54)),
//                         ],
//                       ),
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.indigo.shade300),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BookDetailPage(book: {
//                             "judul": book.title,
//                             "pengarang": book.author,
//                             "tahun": book.year,
//                             "cover": book.safeCoverImageUrl,
//                             "deskripsi": book.description,
//                           }),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
