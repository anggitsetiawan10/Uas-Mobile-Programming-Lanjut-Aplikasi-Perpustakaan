import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../models/review.dart';
import '../services/review_service.dart';
import 'review.dart'; // Untuk halaman edit review

class UserReviewsPage extends StatefulWidget {
  const UserReviewsPage({Key? key}) : super(key: key);

  @override
  State<UserReviewsPage> createState() => _UserReviewsPageState();
}

class _UserReviewsPageState extends State<UserReviewsPage>
    with AutomaticKeepAliveClientMixin<UserReviewsPage>, WidgetsBindingObserver, RouteAware {
  late Future<List<Review>> _futureReviews;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadReviews();
  }

  void _loadReviews() {
    setState(() {
      _futureReviews = ReviewService().fetchUserReviews();
    });
  }

  Future<void> _onRefresh() async {
    _loadReviews();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadReviews();
    }
  }

  @override
  void didPopNext() {
    _loadReviews();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _hapusReview(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Review?"),
        content: const Text("Yakin ingin menghapus review ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ReviewService().deleteReview(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Review berhasil dihapus")),
        );
        _loadReviews();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Gagal menghapus review")),
        );
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder<List<Review>>(
        future: _futureReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("❌ Gagal memuat review: ${snapshot.error}"));
          }

          final reviews = snapshot.data!;
          if (reviews.isEmpty) {
            return const Center(child: Text("📭 Belum ada review"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Gambar buku
                          Container(
                            width: 60,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                              image: DecorationImage(
                                image: NetworkImage(review.coverImageUrl ?? ''),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Detail review
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.bookTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: List.generate(
                                    5,
                                        (i) => Icon(
                                      i < review.rating ? Icons.star : Icons.star_border,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  review.comment,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReviewPage(
                                    book: review.toBook(), // convert review to Book object
                                    existingReview: review,
                                    initialRating: review.rating.toDouble(),
                                  ),
                                ),
                              );
                              if (updated == true) _loadReviews();
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit"),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () => _hapusReview(review.id),
                            icon: const Icon(Icons.delete, size: 18),
                            label: const Text("Hapus"),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
