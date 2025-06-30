import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/book_model.dart';
import '../models/loan_model.dart';
import '../services/loan_service.dart';

class PeminjamanPage extends StatefulWidget {
  final Book book;

  const PeminjamanPage({super.key, required this.book});

  @override
  State<PeminjamanPage> createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final dueDate = selectedDate.add(const Duration(days: 7));

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "📚 Peminjaman Buku",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold, // ✅ BOLD
            fontSize: 20, // opsional: biar lebih besar dan jelas
          ),
        ),
        backgroundColor: Colors.indigo,
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
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(widget.book.safeCoverImageUrl, height: 200),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(widget.book.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("👤 Penulis: ${widget.book.author}",
                      style: const TextStyle(fontSize: 16, color: Colors.black87)),
                  const Divider(height: 30, thickness: 1.5),
                  const Text("📅 Tanggal Pinjam:", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_calendar),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 30)),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("📌 Jatuh Tempo: ${DateFormat('yyyy-MM-dd').format(dueDate)}",
                      style: const TextStyle(fontSize: 16, color: Colors.redAccent)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
                : const Icon(Icons.check),
            label: Text(
              isLoading ? "Memproses..." : "Konfirmasi Peminjaman",
              style: const TextStyle(fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isLoading ? null : _submitLoan,
          ),
        ),
      ),
    );
  }

  Future<void> _submitLoan() async {
    setState(() => isLoading = true);

    final success = await LoanService().createLoan(
      Loan(
        bookId: widget.book.id,
        loanDate: selectedDate,
        dueDate: selectedDate.add(const Duration(days: 7)),
        status: 'dibooking',
      ),
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Peminjaman berhasil")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Gagal meminjam buku")),
      );
    }
  }
}
