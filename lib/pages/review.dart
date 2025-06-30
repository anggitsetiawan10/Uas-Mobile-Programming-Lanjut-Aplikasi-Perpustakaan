// review_page.dart (Refactored with better UI and edit support)
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/review.dart';
import '../services/review_service.dart';

class ReviewPage extends StatefulWidget {
  final Book book;
  final Review? existingReview;

  const ReviewPage({
    super.key,
    required this.book,
    this.existingReview, required double initialRating,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late double _rating;
  late TextEditingController _commentController;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _rating = widget.existingReview?.rating.toDouble() ?? 0.0;
    _commentController = TextEditingController(
        text: widget.existingReview?.comment ?? '');
  }

  Widget _buildStarRating() {
    return Wrap(
      spacing: 4,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return IconButton(
          icon: Icon(
            _rating >= starIndex ? Icons.star : Icons.star_border,
            color: Colors.amber,
            size: 32,
          ),
          onPressed: () => setState(() => _rating = starIndex.toDouble()),
        );
      }),
    );
  }

  Future<void> _submitReview() async {
    if (_rating < 1) return;
    setState(() => _loading = true);

    final review = Review(
      id: widget.existingReview?.id ?? 0,
      bookId: widget.book.id,
      bookTitle: widget.book.title,
      coverImageUrl: widget.book.coverImageUrl,
      rating: _rating.toInt(),
      comment: _commentController.text,
    );

    bool success;
    if (widget.existingReview != null) {
      success = await ReviewService().updateReview(review.id, review);
    } else {
      success = await ReviewService().createReview(review);
    }

    if (context.mounted) {
      setState(() => _loading = false);
      if (success) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Gagal menyimpan review')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(widget.existingReview == null ? 'Tulis Review' : 'Edit Review', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.book.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("Rating", style: TextStyle(fontSize: 16)),
            _buildStarRating(),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Tulis ulasanmu di sini...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: Text(widget.existingReview == null ? 'Kirim Review' : 'Simpan Perubahan',
                  style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold, // ✅ BOLD
                  fontSize: 20,
                ),
              ),
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../models/book_model.dart';
//
// class ReviewPage extends StatefulWidget {
//   final Book book;
//   final double initialRating;
//
//   ReviewPage({required this.book, this.initialRating = 0.0});
//
//   @override
//   _ReviewPageState createState() => _ReviewPageState();
// }
//
// class _ReviewPageState extends State<ReviewPage> {
//   late double _currentRating;
//   final TextEditingController _reviewController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _currentRating = widget.initialRating;
//   }
//
//   Widget _buildStarRating() {
//     return Wrap(
//       spacing: 4,
//       children: List.generate(10, (index) {
//         final value = (index + 1) * 0.5;
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               _currentRating = value;
//             });
//           },
//           child: Icon(
//             _currentRating >= value
//                 ? Icons.star
//                 : (_currentRating >= value - 0.25 ? Icons.star_half : Icons.star_border),
//             color: Colors.amber,
//           ),
//         );
//       }),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tulis Review"),
//         backgroundColor: Colors.indigo,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(widget.book.title, style: const TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),
//             _buildStarRating(),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _reviewController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 hintText: "Tulis ulasanmu di sini...",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // ⏺ Di sini kamu bisa tambahkan logic kirim ke API
//                 Navigator.pop(context, _currentRating);
//               },
//               child: const Text("Kirim Review"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.indigo,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
