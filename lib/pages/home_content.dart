import 'package:flutter/material.dart';
import 'package:perpustakaanid/pages/peminjaman.dart';
import '../main.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import 'book_detail.dart';
import 'latest_books_page.dart';
import 'most_borrowed_books_page.dart';
import 'top_rated_books_page.dart';

class HomeContentPage extends StatefulWidget {
  @override
  _HomeContentPageState createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  List<Book> _latestBooks = [];
  List<Book> _mostBorrowedBooks = [];
  List<Book> _topRatedBooks = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAllBooks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadAllBooks();
    }
  }

  @override
  void didPopNext() {
    _loadAllBooks();
  }

  Future<void> _loadAllBooks() async {
    try {
      final latest = await BookService().fetchLatestBooks();
      final borrowed = await BookService().fetchMostBorrowedBooks();
      final rated = await BookService().fetchTopRatedBooks();
      setState(() {
        _latestBooks = latest.take(5).toList();
        _mostBorrowedBooks = borrowed.take(5).toList();
        _topRatedBooks = rated.take(5).toList();
      });
    } catch (e) {
      print("❌ Gagal memuat buku: $e");
    }
  }

  Widget _buildBookList(String title, List<Book> books) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  if (title.contains("Buku Baru")) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LatestBooksPage()));
                  } else if (title.contains("Dipinjam")) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MostBorrowedBooksPage()));
                  } else if (title.contains("Rating")) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TopRatedBooksPage()));
                  }
                },
                child: const Text("Selengkapnya"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailPage(book: book),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            book.safeCoverImageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 130,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  book.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  book.author,
                                  style: const TextStyle(fontSize: 12),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text("Tahun: ${book.year}", style: const TextStyle(fontSize: 12)),
                                const Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      print("➕ Booking buku: ${book.title}");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PeminjamanPage(book: book),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.add, size: 16),
                                    label: const Text("Booking"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 6),
                                      textStyle: const TextStyle(fontSize: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _loadAllBooks,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _buildBookList("📚 Buku Baru", _latestBooks),
          _buildBookList("🔥 Paling Banyak Dipinjam", _mostBorrowedBooks),
          _buildBookList("⭐ Rating Tertinggi", _topRatedBooks),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// import 'package:flutter/material.dart';
// import 'package:perpustakaanid1/pages/peminjaman.dart';
// import '../main.dart';
// import '../models/book_model.dart';
// import '../services/book_service.dart';
// import 'book_detail.dart';
// import 'latest_books_page.dart';
// import 'most_borrowed_books_page.dart';
// import 'top_rated_books_page.dart';
//
// class HomeContentPage extends StatefulWidget {
//   @override
//   _HomeContentPageState createState() => _HomeContentPageState();
// }
//
// class _HomeContentPageState extends State<HomeContentPage>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
//   List<Book> _latestBooks = [];
//   List<Book> _mostBorrowedBooks = [];
//   List<Book> _topRatedBooks = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _loadAllBooks();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _loadAllBooks();
//     }
//   }
//
//   @override
//   void didPopNext() {
//     _loadAllBooks();
//   }
//
//   Future<void> _loadAllBooks() async {
//     try {
//       final latest = await BookService().fetchLatestBooks();
//       final borrowed = await BookService().fetchMostBorrowedBooks();
//       final rated = await BookService().fetchTopRatedBooks();
//       setState(() {
//         _latestBooks = latest.take(5).toList();
//         _mostBorrowedBooks = borrowed.take(5).toList();
//         _topRatedBooks = rated.take(5).toList();
//       });
//     } catch (e) {
//       print("❌ Gagal memuat buku: $e");
//     }
//   }
//
//   Widget _buildBookList(String title, List<Book> books) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               TextButton(
//                 onPressed: () {
//                   if (title.contains("Buku Baru")) {
//                     Navigator.push(context, MaterialPageRoute(builder: (_) => LatestBooksPage()));
//                   } else if (title.contains("Dipinjam")) {
//                     Navigator.push(context, MaterialPageRoute(builder: (_) => MostBorrowedBooksPage()));
//                   } else if (title.contains("Rating")) {
//                     Navigator.push(context, MaterialPageRoute(builder: (_) => TopRatedBooksPage()));
//                   }
//                 },
//                 child: const Text("Selengkapnya"),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 280,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final book = books[index];
//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => BookDetailPage(book: {
//                         "judul": book.title,
//                         "pengarang": book.author,
//                         "tahun": book.year,
//                         "cover": book.safeCoverImageUrl,
//                         "deskripsi": book.description,
//                       }),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: 160,
//                   margin: const EdgeInsets.symmetric(horizontal: 8),
//                   child: Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         ClipRRect(
//                           borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                           child: Image.network(
//                             book.safeCoverImageUrl,
//                             height: 130,
//                             width: double.infinity,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (context, child, progress) {
//                               if (progress == null) return child;
//                               return const Center(child: CircularProgressIndicator());
//                             },
//                             errorBuilder: (context, error, stackTrace) {
//                               return Container(
//                                 height: 130,
//                                 color: Colors.grey[300],
//                                 child: const Icon(Icons.broken_image, size: 50),
//                               );
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   book.title,
//                                   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   book.author,
//                                   style: const TextStyle(fontSize: 12),
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 const SizedBox(height: 2),
//                                 Text("Tahun: ${book.year}", style: const TextStyle(fontSize: 12)),
//                                 const Spacer(),
//                                 SizedBox(
//                                   width: double.infinity,
//                                   child: ElevatedButton.icon(
//                                     onPressed: () {
//                                       print("➕ Booking buku: ${book.title}");
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (_) => PeminjamanPage(book: book),
//                                         ),
//                                       );
//                                     },
//                                     icon: const Icon(Icons.add, size: 16),
//                                     label: const Text("Booking"),
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor: Colors.indigo,
//                                       foregroundColor: Colors.white,
//                                       padding: const EdgeInsets.symmetric(vertical: 6),
//                                       textStyle: const TextStyle(fontSize: 12),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                   ),
//
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return RefreshIndicator(
//       onRefresh: _loadAllBooks,
//       child: ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           _buildBookList("📚 Buku Baru", _latestBooks),
//           _buildBookList("🔥 Paling Banyak Dipinjam", _mostBorrowedBooks),
//           _buildBookList("⭐ Rating Tertinggi", _topRatedBooks),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }
