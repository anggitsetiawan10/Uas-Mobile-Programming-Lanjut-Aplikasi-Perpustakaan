import 'package:flutter/material.dart';
import '../main.dart'; // Pastikan routeObserver di-declare di sini
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../services/category_service.dart';
import '../services/year_service.dart';
import 'book_detail.dart';

class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
  final TextEditingController _searchController = TextEditingController();
  List<String> genres = [];
  List<String> years = [];
  String selectedGenre = '';
  String selectedYear = '';
  List<Book> _searchResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController.addListener(_onSearchChanged);
    _loadCategoriesAndYears();
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _performSearch();
    }
  }

  @override
  void didPopNext() {
    _performSearch();
  }

  void _onSearchChanged() {
    _performSearch();
  }

  Future<void> _loadCategoriesAndYears() async {
    try {
      final fetchedGenres = await CategoryService().fetchCategories();
      final fetchedYears = await YearService().fetchYears();
      setState(() {
        genres = fetchedGenres.map((g) => g.name).toList();
        years = fetchedYears;
      });
    } catch (e) {
      print('❌ Gagal memuat kategori/tahun: $e');
    }
  }

  Future<void> _performSearch() async {
    final keyword = _searchController.text.trim();
    try {
      final books = await BookService().searchBooks(
        keyword: keyword.isNotEmpty ? keyword : null,
        category: selectedGenre.isNotEmpty ? selectedGenre : null,
        year: selectedYear.isNotEmpty ? selectedYear : null,
      );
      setState(() {
        _searchResults = books;
      });
    } catch (e) {
      print("❌ Gagal mencari buku: $e");
    }
  }

  Widget _buildFilterChips(
      String title,
      List<String> options,
      String selectedValue,
      Function(String) onSelected,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Wrap(
          spacing: 8,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedValue == option,
              onSelected: (selected) {
                setState(() {
                  onSelected(selected ? option : '');
                  _performSearch();
                });
              },
              selectedColor: Colors.indigo,
              backgroundColor: Colors.grey[200],
              labelStyle: TextStyle(
                color: selectedValue == option ? Colors.white : Colors.black,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("🔍 Tidak ada hasil ditemukan."),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final book = _searchResults[index];
        return ListTile(
          leading: Image.network(
            book.safeCoverImageUrl,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
          title: Text(book.title),
          subtitle: Text('${book.author} • ${book.year} • ${book.category ?? 'Tanpa Kategori'}'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(book: book), // ✅ Fix: Kirim langsung objek Book
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await _loadCategoriesAndYears();
        await _performSearch();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '🔍 Cari berdasarkan judul, penulis...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildFilterChips("📖 Berdasarkan Genre", genres, selectedGenre,
                    (value) => selectedGenre = value),
            const SizedBox(height: 8),
            _buildFilterChips("📅 Berdasarkan Tahun", years, selectedYear,
                    (value) => selectedYear = value),
            const SizedBox(height: 16),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../main.dart'; // Pastikan routeObserver di-declare di sini
// import '../models/book_model.dart';
// import '../services/book_service.dart';
// import '../services/category_service.dart';
// import '../services/year_service.dart';
// import 'book_detail.dart';
//
// class SearchingPage extends StatefulWidget {
//   @override
//   _SearchingPageState createState() => _SearchingPageState();
// }
//
// class _SearchingPageState extends State<SearchingPage>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, RouteAware {
//   final TextEditingController _searchController = TextEditingController();
//   List<String> genres = [];
//   List<String> years = [];
//   String selectedGenre = '';
//   String selectedYear = '';
//   List<Book> _searchResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _searchController.addListener(_onSearchChanged);
//     _loadCategoriesAndYears();
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
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _performSearch();
//     }
//   }
//
//   @override
//   void didPopNext() {
//     _performSearch();
//   }
//
//   void _onSearchChanged() {
//     _performSearch();
//   }
//
//   Future<void> _loadCategoriesAndYears() async {
//     try {
//       final fetchedGenres = await CategoryService().fetchCategories();
//       final fetchedYears = await YearService().fetchYears();
//       setState(() {
//         genres = fetchedGenres.map((g) => g.name).toList();
//         years = fetchedYears;
//       });
//     } catch (e) {
//       print('❌ Gagal memuat kategori/tahun: $e');
//     }
//   }
//
//   Future<void> _performSearch() async {
//     final keyword = _searchController.text.trim();
//     try {
//       final books = await BookService().searchBooks(
//         keyword: keyword.isNotEmpty ? keyword : null,
//         category: selectedGenre.isNotEmpty ? selectedGenre : null,
//         year: selectedYear.isNotEmpty ? selectedYear : null,
//       );
//       setState(() {
//         _searchResults = books;
//       });
//     } catch (e) {
//       print("❌ Gagal mencari buku: $e");
//     }
//   }
//
//   Widget _buildFilterChips(
//       String title,
//       List<String> options,
//       String selectedValue,
//       Function(String) onSelected,
//       ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
//           child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         ),
//         Wrap(
//           spacing: 8,
//           children: options.map((option) {
//             return ChoiceChip(
//               label: Text(option),
//               selected: selectedValue == option,
//               onSelected: (selected) {
//                 setState(() {
//                   onSelected(selected ? option : '');
//                   _performSearch();
//                 });
//               },
//               selectedColor: Colors.indigo,
//               backgroundColor: Colors.grey[200],
//               labelStyle: TextStyle(
//                 color: selectedValue == option ? Colors.white : Colors.black,
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSearchResults() {
//     if (_searchResults.isEmpty) {
//       return const Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Text("🔍 Tidak ada hasil ditemukan."),
//       );
//     }
//
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: _searchResults.length,
//       itemBuilder: (context, index) {
//         final book = _searchResults[index];
//         return ListTile(
//           leading: Image.network(
//             book.safeCoverImageUrl,
//             width: 50,
//             height: 70,
//             fit: BoxFit.cover,
//           ),
//           title: Text(book.title),
//           subtitle: Text('${book.author} • ${book.year} • ${book.category ?? 'Tanpa Kategori'}'),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => BookDetailPage(book: {
//                   "judul": book.title,
//                   "pengarang": book.author,
//                   "tahun": book.year,
//                   "cover": book.safeCoverImageUrl,
//                   "deskripsi": book.description,
//                 }),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context); // penting untuk keepAlive
//     return RefreshIndicator(
//       onRefresh: () async {
//         await _loadCategoriesAndYears();
//         await _performSearch();
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: '🔍 Cari berdasarkan judul, penulis...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 12),
//             _buildFilterChips("📖 Berdasarkan Genre", genres, selectedGenre,
//                     (value) => selectedGenre = value),
//             const SizedBox(height: 8),
//             _buildFilterChips("📅 Berdasarkan Tahun", years, selectedYear,
//                     (value) => selectedYear = value),
//             const SizedBox(height: 16),
//             _buildSearchResults(),
//           ],
//         ),
//       ),
//     );
//   }
// }
