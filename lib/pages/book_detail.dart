import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'peminjaman.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(book.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEDE7F6)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(book.safeCoverImageUrl, height: 200),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("Pengarang: ${book.author}", style: const TextStyle(fontSize: 16)),
                  Text("Tahun Terbit: ${book.year}", style: const TextStyle(fontSize: 16)),
                  const Divider(height: 30, thickness: 1.5),
                  const Text("Deskripsi:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(book.description ?? 'Deskripsi tidak tersedia.', textAlign: TextAlign.justify),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PeminjamanPage(book: book),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text("Booking Buku Ini"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class BookDetailPage extends StatelessWidget {
//   final Map<String, String?> book;
//
//   const BookDetailPage({super.key, required this.book});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         iconTheme: const IconThemeData(color: Colors.white), // Arrow putih
//         title: Text(
//           book['judul'] ?? 'Detail Buku',
//           style: const TextStyle(color: Colors.white), // Judul putih
//         ),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.white, Color(0xFFEDE7F6)],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Card(
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//             elevation: 5,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: book['cover'] != null
//                           ? Image.network(book['cover']!, height: 200)
//                           : Container(
//                         height: 200,
//                         color: Colors.grey[300],
//                         child: const Icon(Icons.broken_image, size: 80),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     book['judul'] ?? 'Judul tidak tersedia',
//                     style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text("Pengarang: ${book['pengarang'] ?? '-'}",
//                       style: const TextStyle(fontSize: 16, color: Colors.black87)),
//                   Text("Tahun Terbit: ${book['tahun'] ?? '-'}",
//                       style: const TextStyle(fontSize: 16, color: Colors.black87)),
//                   const Divider(height: 30, thickness: 1.5),
//                   const Text("Deskripsi:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   Text(
//                     book['deskripsi'] ?? 'Deskripsi tidak tersedia.',
//                     style: const TextStyle(fontSize: 15, color: Colors.black87),
//                     textAlign: TextAlign.justify,
//                   ),
//                   const SizedBox(height: 30),
//                   Center(
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         // Booking action
//                       },
//                       icon: const Icon(Icons.add),
//                       label: const Text("Booking Buku Ini"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                         textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         elevation: 4,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
