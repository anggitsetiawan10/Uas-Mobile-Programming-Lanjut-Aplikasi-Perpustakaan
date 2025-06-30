import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController idController = TextEditingController();

  void _sendRequest() async {
    String id = idController.text.trim();

    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Silakan masukkan ID Anda")),
      );
      return;
    }

    final String adminPhone = "6289674595181"; // Format internasional
    final String message = Uri.encodeComponent(
      "Halo Admin, saya ingin mereset kata sandi saya.\nID: $id",
    );

    final Uri whatsappUrl = Uri.parse("https://wa.me/$adminPhone?text=$message");

    // Coba buka dengan WhatsApp
    final bool canOpen = await canLaunchUrl(whatsappUrl);
    if (canOpen) {
      try {
        final bool launched = await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
        if (!launched) throw Exception("Gagal diluncurkan di WhatsApp");
      } catch (_) {
        // Fallback ke browser
        await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
      }
    } else {
      // Fallback langsung ke browser
      await launchUrl(whatsappUrl, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Kata Sandi", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan ID atau Email Anda untuk mengirim permintaan reset kata sandi ke admin melalui WhatsApp.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                labelText: "ID Anggota / Email",
                hintText: "Contoh: STI202201234",
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _sendRequest,
              icon: const Icon(Icons.send, color: Colors.white),
              label: const Text("Kirim Permintaan", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
