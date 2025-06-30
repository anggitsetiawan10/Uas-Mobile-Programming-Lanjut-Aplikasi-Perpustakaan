import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constans/api.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';
import '../services/auth_service.dart';
import '../pages/review.dart';

class LoanListPage extends StatefulWidget {
  @override
  _LoanListPageState createState() => _LoanListPageState();
}

class _LoanListPageState extends State<LoanListPage> {
  late Future<List<Loan>> _loanFuture;

  @override
  void initState() {
    super.initState();
    _loanFuture = LoanService().fetchUserLoans();
  }

  Future<void> _refreshLoans() async {
    setState(() {
      _loanFuture = LoanService().fetchUserLoans();
    });
  }

  Future<void> _hapusLoan(int id) async {
    final token = await AuthService().getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/loans/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Booking berhasil dibatalkan')),
      );
      _refreshLoans();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Gagal membatalkan booking')),
      );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}/${date.month}/${date.year}";
  }

  Widget _buildLoanCard(Loan loan) {
    final bisaHapus = loan.status == 'dibooking';
    final bisaReview = loan.status == 'dikembalikan';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loan.book?.title ?? "Judul tidak tersedia",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              '📅 ${_formatDate(loan.loanDate)} s/d ${_formatDate(loan.dueDate)}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              '📌 Status: ${loan.status ?? "-"}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: bisaReview && loan.book != null
                        ? () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReviewPage(
                          book: loan.book!,
                          initialRating: 0.0,
                        ),
                      ),
                    )
                        : null,
                    icon: const Icon(Icons.rate_review, size: 18),
                    label: const Text("Review"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bisaReview ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: bisaHapus ? () => _hapusLoan(loan.id!) : null,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: bisaHapus ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Peminjaman',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Loan>>(
        future: _loanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('❌ Error: ${snapshot.error}'));
          }

          final loans = snapshot.data!;
          if (loans.isEmpty) {
            return const Center(child: Text('📭 Tidak ada peminjaman.'));
          }

          return RefreshIndicator(
            onRefresh: _refreshLoans,
            child: ListView.builder(
              itemCount: loans.length,
              itemBuilder: (context, index) => _buildLoanCard(loans[index]),
            ),
          );
        },
      ),
    );
  }
}
